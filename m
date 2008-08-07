Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbYHGUo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbYHGUo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYHGUoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:44:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36547 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbYHGUoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:44:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Please fix x86 defconfig regression
Date: Thu, 7 Aug 2008 22:46:41 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080806173829.GA8702@gargoyle>
In-Reply-To: <20080806173829.GA8702@gargoyle>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808072246.42301.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 6 of August 2008, Andi Kleen wrote:
> 
> commit 5cb04df8d3f03e37a19f2502591a84156be71772
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Sun May 4 19:49:04 2008 +0200
> 
>     x86: defconfig updates
>     
>     refresh 32-bit defconfig too, and update the 64-bit configs as well,
>     the defconfig should be much more useful by default, so most of the
>     updates are the enabling of various options.
> 
> updates the x86 defconfigs. Unfortunately contrary to its description
> it disables lots of important options:
> 
> including NFS and NFS root support
> 
> -CONFIG_IP_PNP=y
> -CONFIG_IP_PNP_DHCP=y
> -# CONFIG_IP_PNP_BOOTP is not set
> -# CONFIG_IP_PNP_RARP is not set
> 
> and disabling even common ethernet drivers like
> 
> -CONFIG_8139CP=y
> +# CONFIG_8139CP is not set
> -CONFIG_B44=y
> -CONFIG_TULIP=y
> -CONFIG_E1000E=y
> -CONFIG_E1000E_ENABLED=y
> -CONFIG_BNX2=y
> 
> and worst completely disabling NFS
> 
> +# CONFIG_NFS_FS is not set
> +# CONFIG_NFSD is not set
> 
> These changes broke my test setup completely.
> 
> Also it has a few other questionable changes like:
> 
> -CONFIG_X86_GENERICARCH=y
> +# CONFIG_X86_GENERICARCH is not set
> -CONFIG_X86_GENERIC=y
> 
> which means it won't run on old CPUs anymore.
> Where should GENERICARCH/X86_GENERIC not be set but in a defconfig?
> 
> And the IDE change will likely break lots of boot setups:
> 
> -CONFIG_IDE=y
> -CONFIG_BLK_DEV_IDE=y
> 
> because the root device name will change suddenly and many distros
> or initrd less setups cannot deal with that.
> 
> Also undoubtedly that will also break people's system (reiserfs
> is still widely used):
> 
> -CONFIG_REISERFS_FS=y
> -# CONFIG_REISERFS_CHECK is not set
> -# CONFIG_REISERFS_PROC_INFO is not set
> 
> This breaks reading a lot of joliet and vfat file systems:
> 
> -CONFIG_NLS_ISO8859_15=y
> +# CONFIG_NLS_ISO8859_15 is not set
> 
> This breaks older glibc userland (shipped in at least one SUSE 
> distribution release):
> 
> +# CONFIG_COMPAT_VDSO is not set
> 
> This will break a lot of older server systems:
> 
> -CONFIG_SCSI_AIC7XXX=y
> 
> Various other issues.
> 
> Rafael, can you please add all that to the regression list? Thanks.

I would, but it didn't make it to any list archives I know of, so there's no
link to put in there.  I'll link it to my reply if that's available somewhere.

> In general defconfig should only add things, but very rarely
> remove any. The best would be probably to revert that commit and
> redo whatever options it wanted to add on top of the previous
> defconfigs.

Thanks,
Rafael
