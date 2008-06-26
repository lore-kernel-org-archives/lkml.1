Return-Path: <linux-kernel-owner+w=401wt.eu-S1760856AbYFZSHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856AbYFZSHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYFZSHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:07:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52976 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbYFZSHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:07:06 -0400
Message-ID: <4863D930.2040300@kernel.org>
Date: Thu, 26 Jun 2008 11:00:16 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Bernhard Walle <bwalle@suse.de>, Vivek Goyal <vgoyal@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
References: <1214423826-12628-1-git-send-email-bwalle@suse.de>	<1214423826-12628-2-git-send-email-bwalle@suse.de>	<20080625224301.GE32344@redhat.com>	<18531.20387.111875.576837@harpo.it.uu.se>	<20080626104524.2d7ed1ab@halley.suse.de> <18531.23894.572847.322265@harpo.it.uu.se>
In-Reply-To: <18531.23894.572847.322265@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Bernhard Walle writes:
>  > > It should be configurable. Whether it's done via CONFIG_KEXEC or its own
>  > > option I don't care.
>  > 
>  > Ok, changed:
>  > 
>  > diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
>  > index 1008737..73fcc59 100644
>  > --- a/drivers/firmware/Kconfig
>  > +++ b/drivers/firmware/Kconfig
>  > @@ -28,7 +28,7 @@ config EDD_OFF
>  >  
>  >  config FIRMWARE_MEMMAP
>  >      def_bool y
>  > -    depends on X86_64 || X86_32
>  > +    depends on (X86_64 || X86_32) && KEXEC
>  >  
>  >  config EFI_VARS
>  >         tristate "EFI Variable Support via sysfs"
> 
> Yep, thanks.
> 

Making this depend on KEXEC would be most unfortunate.  This is valuable 
information for finding all kinds of issues even in the absence of KEXEC.

I really don't see a point in making this configurable, except perhaps 
under CONFIG_EMBEDDED.

	-hpa
