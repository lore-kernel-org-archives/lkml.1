Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZGBBEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZGBBEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbZGBBES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:04:18 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:57498 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZGBBER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:04:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Fe4akczbiOVs5KgfUQS2DF/z8ZVvTVuGkuSPwkxufTof9tSvUknb7F2ELv64O0839r
         UPx4e7Jyzfat+OLpHuWRXPDbgVBNCWotedr4skM7SBx7TBMaHKMGPCKzQmAotXFRq7nn
         WE5pl3IBq5TPmDq7VASXb89qEoIpd7sXuNyFY=
Subject: Re: [BUG] MIPS: Hibernation in the latest linux-mips:master branch
 not work
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20090701180715.GA23121@linux-mips.org>
References: <1246372868.19049.17.camel@falcon>
	 <20090630144540.GA18212@linux-mips.org> <1246374687.20482.10.camel@falcon>
	 <20090701180715.GA23121@linux-mips.org>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Thu, 02 Jul 2009 09:04:07 +0800
Message-Id: <1246496647.9660.46.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 19:07 +0100, Ralf Baechle wrote:
> On Tue, Jun 30, 2009 at 11:11:27PM +0800, Wu Zhangjin wrote:
> 
> > hi, ralf, in the latest master branch of linux-mips git repo, seems
> > there is a need to select the SYS_SUPPORTS_HOTPLUG_CPU option in every
> > uni-processor board, otherwise, the suspend/hibernation can not be used,
> > because you have set:
> > 
> > config ARCH_HIBERNATION_POSSIBLE
> >     def_bool y
> >     depends on SYS_SUPPORTS_HOTPLUG_CPU
> > 
> > config ARCH_SUSPEND_POSSIBLE
> >     def_bool y
> >     depends on SYS_SUPPORTS_HOTPLUG_CPU
> > 
> > so, the board-specific patch must be pushed by the maintainers of
> > boards. and if the board support SMP, they must implement the
> > mips-specific hotplug support, is this right? I have selected
> > SYS_SUPPORTS_HOTPLUG_CPU in LEMOTE_FULONG and will push a relative patch
> > later.
> 
> I think below patch should take care of this problem.  It simply assumes
> that all uniprocessor systems support suspend and hibernate.  That's an
> assumption that I'm not to unhappy with though it may force us to fix a
> few systems.
> 

This patch is better.

Thanks!
Wu Zhangjin

>   Ralf
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
>  arch/mips/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index df1a92a..3ca0fe1 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -2168,11 +2168,11 @@ menu "Power management options"
>  
>  config ARCH_HIBERNATION_POSSIBLE
>  	def_bool y
> -	depends on SYS_SUPPORTS_HOTPLUG_CPU
> +	depends on SYS_SUPPORTS_HOTPLUG_CPU || !SMP
>  
>  config ARCH_SUSPEND_POSSIBLE
>  	def_bool y
> -	depends on SYS_SUPPORTS_HOTPLUG_CPU
> +	depends on SYS_SUPPORTS_HOTPLUG_CPU || !SMP
>  
>  source "kernel/power/Kconfig"
>  

