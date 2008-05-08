Return-Path: <linux-kernel-owner+w=401wt.eu-S1763385AbYEHOri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763385AbYEHOri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYEHOr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:47:28 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:32775 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYEHOr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:47:26 -0400
X-Greylist: delayed 1460 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2008 10:47:26 EDT
Message-ID: <48230C7B.90007@mandriva.org>
Date: Thu, 08 May 2008 17:21:47 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, linux-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch, -git] drivers/media build fix for modular builds
References: <20080507134907.4417708b.sfr@canb.auug.org.au>
In-Reply-To: <20080507134907.4417708b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell skrev:
> Date:	Wed, 30 Apr 2008 09:48:07 +0200
> From:	Ingo Molnar <mingo@elte.hu>
> To:	Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc:	Linus Torvalds <torvalds@linux-foundation.org>,
> 	Andrew Morton <akpm@linux-foundation.org>,
> 	linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
> 	linux-kernel@vger.kernel.org
> 
> fix allmodconfig build bug introduced in latest -git by commit 
> 7c91f0624a9 ("V4L/DVB(7767): Move tuners to common/tuners"):
> 
>   LD      kernel/built-in.o
>   LD      drivers/built-in.o
>   ld: drivers/media/built-in.o: No such file: No such file or directory
> 
> which happens if all media drivers are modular:
> 
>   http://redhat.com/~mingo/misc/config-Wed_Apr_30_09_24_48_CEST_2008.bad
> 
> In that case there's no obj-y rule connecting all the built-in.o files and
> the link tree breaks.
> 
> the fix is to add a guaranteed obj-y rule for the core vmlinux to build.
> (which results in an empty object file if all media drivers are modular)
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/media/Makefile |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Linus,
> 
> I have been applying a similar patch to linux-next for some time.  It has
> been reported a while ago and does break (at least) powerpc and x86_64
> allmodconfig builds.
> 
> Please apply at you earliest convenience.
> 
> /me tries out his "random-build-fix-monkey" appointment.
> 
> Index: linux/drivers/media/Makefile
> ===================================================================
> --- linux.orig/drivers/media/Makefile
> +++ linux/drivers/media/Makefile
> @@ -2,6 +2,8 @@
>  # Makefile for the kernel multimedia device drivers.
>  #
>  
> +obj-y := common/
> +
>  obj-$(CONFIG_VIDEO_MEDIA) += common/
>  
>  # Since hybrid devices are here, should be compiled if DVB and/or V4L
> 


How about fixing this one already ?

--
Thomas
