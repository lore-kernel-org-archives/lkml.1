Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZBEOc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZBEOc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZBEOcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:32:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60630 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbZBEOcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:32:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL -tip] fix 22 make headers_check - 200901
Date: Thu, 5 Feb 2009 15:30:24 +0100
User-Agent: KMail/1.9.9
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>, mingo@elte.hu, x86@kernel.org,
       sam@ravnborg.org, jirislaby@gmail.com, gregkh@suse.de,
       davem@davemloft.net, xyzzy@speakeasy.org, mchehab@infradead.org,
       jens.axboe@oracle.com, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       netfilter-devel@vger.kernel.org
References: <20090204064307.GA18415@gondor.apana.org.au> <200902041255.53264.arnd@arndb.de> <4989D17F.4030406@zytor.com>
In-Reply-To: <4989D17F.4030406@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902051530.25897.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+xWouqvf8D5HqtUQLs6J608h6d7t3gFJyLxuo
 MM8B6KCSgSS7ymon7yZO/6/gQbpP9hLDNPj5Ol7218nhzJ5SQ6
 QCE4Vxie6ImsR61tfAKKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, H. Peter Anvin wrote:
> 
> Actually, if anything we should move the *non* __KERNEL_STRICT_NAMES out
> of <linux/types.h> into something else, or completely deep-six them.  I
> don't know of any libc which wants these anymore, and I think they're
> just residual libc5 cruft.
> 
> However, if we want <linux/extra_types.h> that's fine with me; but
> <linux/types.h> really should be clean, which means doing what
> __KERNEL_STRICT_NAMES does now.

Right now, we have 15 exported headers [1] that use the non-strict 
posix types (pid_t, off_t, clock_t, ...) and a set of 106 (!)
files [2] using non-strict integer types (u_int32_t, uint32_t, u32, ...),
76 of those alone in netfilter.

Do you think we should fix up all of them before 2.6.29? I'm worried
that we might introduce more regressions in the process.
Also, should we leave netfilter alone, in order to reduce the changes?
I'm also unsure whether a hack in headers_install would be better than
changing the headers in the source tree.

	Arnd <><

[1] for i in dev_t mode_t off_t pid_t suseconds_t timer_t uid_t gid_t \
    loff_t time_t clock_t caddr_t ; do grep \\\<$i\\\> $obj/usr/include ; \
    done | sort | grep -v linux/types.h

[2] grep '\<\(\(u_\|u\|\)int\(8\|16\|32\|64\)_t\|[us]\(8\|16\|32\|64\)\)\>' \
    $obj/usr/include | grep -v linux/types.h
