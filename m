Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZJ1XEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZJ1XEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 19:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZJ1XEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 19:04:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZJ1XEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 19:04:09 -0400
Date: Wed, 28 Oct 2009 16:01:20 -0700
From: Greg KH <gregkh@suse.de>
To: Milan Dadok <milan@dadok.name>
Cc: linux-kernel@vger.kernel.org, "'Hank Janssen'" <hjanssen@microsoft.com>,
       "'Haiyang Zhang'" <haiyangz@microsoft.com>
Subject: Re: [PATCH] 3/3 staging: hv: fix oops in vmbus - missing #include
Message-ID: <20091028230120.GB15420@suse.de>
References: <001601ca581d$5390e0e0$fab2a2a0$@name>
 <20091028223114.GA25962@suse.de>
 <001701ca5821$8a52aec0$9ef80c40$@name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001701ca5821$8a52aec0$9ef80c40$@name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 11:54:00PM +0100, Milan Dadok wrote:
> It's gentoo
> Primary I was working on linux-2.6.31-gentoo 
> gcc-config  -l
>  [1] i686-pc-linux-gnu-4.3.2 *
> 
> 10 Sep 2009; Mike Pagano <mpagano@gentoo.org>
>   +gentoo-sources-2.6.31.ebuild:
>   Initial 2.6.31 release including the fbcondecor patch,, a paoatch to
>   enable control of the unaligned access control policy from sysctl and a
>   patch for bad block relocation support for LiveCD users.
> 
> I already suspected some error on my side, therefor I installed vanilla
> 2.6.32-r5
> Because I cannot made it to compile without #include, I send third patch.
> 
> Now I tried it again - and it look like only #include in osd.h is missing.
> In ChannelMgmt.h is not ...
> 
> My error is (#include workqueue.h commented in osd.h)
> # make SUBDIR=drivers/staging/hv CONFIG_DEBUG_SECTION_MISMATCH=y modules
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CALL    scripts/checksyscalls.sh
>   CC [M]  drivers/staging/hv/blkvsc_drv.o
>   CC [M]  drivers/staging/hv/BlkVsc.o
> In file included from drivers/staging/hv/BlkVsc.c:24:
> drivers/staging/hv/osd.h:68: warning: 'struct workqueue_struct' declared
> inside parameter list
> drivers/staging/hv/osd.h:68: warning: its scope is only this definition or
> declaration, which is probably not what you want

Wierd.  Can you send me your .config file?  I can't duplicate this on
Linus's current git tree at all.

> PS. I have another error with 2.6.32-rc5 - if there is some WARNING mismatch
> in reference, then *.ko is not copied to
> /lib/modules/2.6.32-rc5/kernel/drivers/staging/hv/
> It is correct behaivour of kernel build system?
> 2.6.31 without warning always copied .ko files to /lib

I don't know, I think that means an error is happening somewhere else.

thanks,

greg k-h
