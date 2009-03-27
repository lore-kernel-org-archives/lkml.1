Return-Path: <linux-kernel-owner+w=401wt.eu-S1762156AbZC0Ux2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762156AbZC0Ux2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZC0UxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:53:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64194 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbZC0UxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:53:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 5/13] score - New architecure port to SunplusCT S+CORE processor
Date: Fri, 27 Mar 2009 21:53:05 +0100
User-Agent: KMail/1.9.9
Cc: liqin.chen@sunplusct.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <OFE9A5E3A2.37B73BA8-ON48257586.0008CFAC-48257586.00091B05@sunplusct.com> <200903272019.53689.arnd@arndb.de> <20090327202614.GA22054@uranus.ravnborg.org>
In-Reply-To: <20090327202614.GA22054@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903272153.05622.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18EzIOgKJ5OAIYHsBvKJSV8R1OycshQgPJ8EAI
 cQrfdxIw9Zn0sc9qaBNmMUN2ov8ugh26tlc8qmLny9ejR2uUoF
 xujqynLlboI/qK5sV/XSQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Sam Ravnborg wrote:

> Thats strange indeed.
> This structure will then change layout depending on the target bit-size
> of the compiler.
> 
> From x86:
> #ifdef __i386__
>         unsigned long           __unused1;
> #endif
>         __kernel_time_t         shm_dtime;      /* last detach time */
> #ifdef __i386__
>         unsigned long           __unused2;
> #endif
> 
> long is 64 bit in one case and 32 bit in another case.
> I'm confused..

The idea here is to have the same layout for both by adding
long (32 bit) padding between 32 bit members on i386 and not
having the padding along the __kernel_time_t (which is also
long) members on x86_64. The problem is that some architectures
copying this didn't understand the part about the padding,
while others (big-endian ones) put the padding in the wrong
place by copying from i386.

By now, most of the existing architectures copied the i386
file, which is at least consistent and we've learned to
deal with it. I recommend just using this one as the
asm-generic version and letting all new archs fall back
to that.

> I would expect it to be safer to be bit-size neutral in our
> exported headers.
> But the score people know there userlend best so let them decide.
 
> Still they should audit all their exported headers.
> They cannot assume it was right because they copied them from
> somewhere.

Yes, I agree. Hopefully I'll manage to get my patches into
shape to post the generic versions in the next days so we can use
them on microblaze and score as well as all future versions.

	Arnd <><
