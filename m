Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563AbZBCU2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbZBCU2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZBCU1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:27:53 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZBCU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:27:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: usr/include/linux/soundcard.h warnings for 'make headers_check'
Date: Tue, 3 Feb 2009 21:27:23 +0100
User-Agent: KMail/1.9.9
Cc: Takashi Iwai <tiwai@suse.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       alsa-devel@alsa-project.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <1232465902.3088.31.camel@localhost.localdomain> <s5h7i4psepm.wl%tiwai@suse.de> <20090121054138.GA26551@uranus.ravnborg.org>
In-Reply-To: <20090121054138.GA26551@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032127.24526.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/WIdC04V1h5YE9vEa32yGtbhm1XXOYmE9yKFK
 06i74PPka+rM7rzjw0pJS8qirBtX+kXVs3/VnegfbYrtr+qteU
 LklRkUZGMV2CQOL16DgHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Sam Ravnborg wrote:
> 
> > No, these are declarations for OSS-lib.
> > It doesn't belong to kernel, but it's better to keep it for
> > compatibility in some way.
> 
> But not in the kernel for sure.
> I just checked and for example: OSS_init is not used anywhere in the kernel.
> The kernel headers are not a "dump all your stuff" ground anymore.
> 
> So I encourage you to find a better home for the user space library definitons.
> We can let the definiton stay for a while - but eventually they have to
> be dropped from the kernel.

The last free version of OSSlib that matches this header is from ~1997, and
no current distro appears to be shipping it. All new OSSlib versions (the
oldest I found was from ~2003) contain in their documentation:

"Older versions of some OSS include files are distributed
 with various operating systems. There is no danger in
 using them but applications written for more recent OSS
 versions will not compile with older header files.

 The latest versions of these include files (such as
 soundcard.h) are distributed in ../include/sys. Use
 the -I/usr/lib/oss/include switch when compiling
 programs. Alternatively copy these files to /usr/include/sys
 so that they replace the original ones."

I think it's safe enough to assume that everyone that builds against
OSSlib by now also has the correct version of the header installed.
Consequently, we should just drop the #ifndef __KERNEL__ section
of soundcard.h (all the macros in there depend on the extern
declarations), and maybe add an

#ifdef OSSLIB
#error need to use <sys/soundcard.h> from libOSSlib
#endif

	Arnd <><
