Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbZGaRQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbZGaRQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZGaRQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:16:39 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:63029 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbZGaRQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:16:38 -0400
From: Frans Pop <elendil@planet.nl>
To: David Howells <dhowells@redhat.com>
Subject: Re: RomFS: enless loop during make oldconfig from 2.6.24 -> 2.6.31-rc4 (parisc)
Date: Fri, 31 Jul 2009 19:16:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       David Woodhouse <David.Woodhouse@intel.com>
References: <200907311730.08804.elendil@planet.nl> <17615.1249045054@redhat.com> <18884.1249058776@redhat.com>
In-Reply-To: <18884.1249058776@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907311916.37389.elendil@planet.nl>
X-OriginalArrivalTime: 31 Jul 2009 17:16:37.0946 (UTC) FILETIME=[A9ADE1A0:01CA1202]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009, David Howells wrote:
> Frans Pop <elendil@planet.nl> wrote:
> > I've tried again too. With all defaults I cannot reproduce it either.
> > But if I answer the questions below as follows, I do get the loop
> > again:
> >
> > Advanced netfilter configuration: N
> > Wireless: N
> > * sound drivers: N (* = "PCI","USB" and one or two others)
> > Default ext3 to "data=ordered": Y
>
> I still don't see it.  I have:
>
> 	# CONFIG_NETFILTER_ADVANCED is not set
> 	# CONFIG_WIRELESS is not set
> 	# CONFIG_SND_PCI is not set
> 	# CONFIG_SND_SPI is not set
> 	# CONFIG_SND_USB is not set
> 	# CONFIG_SND_GSC is not set
> 	# CONFIG_SND_SOC is not set
> 	CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
>
> Can you accept all the defaults, then delete the above symbols from
> .config and run make oldconfig again, see if the problem crops up?

No, I can not reproduce it that way. But I have just reproduced it for a
third time giving those answers starting from the original .config. So
the "good" news is that at least it's reproducible for me.

My guess is it's not a RomFS issue, but rather some kbuild weirdness
(and maybe even architecture or userland related).
Note how in the loop the help text for ROMFS_BACKED_BY_BLOCK gets
displayed somehow, while in the normal case you don't get that.

With all default answers, I get:
<snip>
  ROM file system support (ROMFS_FS) [M/n/y/?] m
    RomFS backing stores
    > 1. Block device-backed ROM file system support (ROMFS_BACKED_BY_BLOCK) (NEW)
    choice[1]: 1
  System V/Xenix/V7/Coherent file system support (SYSV_FS) [N/m/y/?] n
  UFS file system support (read only) (UFS_FS) [N/m/y/?] n
  NILFS2 file system support (EXPERIMENTAL) (NILFS2_FS) [N/m/y/?] (NEW)
</snip>

Compared to what I get in the loop:
<snip>
    RomFS backing stores
    > 1. Block device-backed ROM file system support (ROMFS_BACKED_BY_BLOCK) (NEW)
    choice[1]: 1

This permits ROMFS to use block devices buffered through the page
cache as the medium from which to retrieve data.  It does not allow
direct mapping of the medium.

If unsure, answer Y.
</snip>

Is there some debugging mode for 'make oldconfig'? Or maybe we should
just wait until Sam can comment.


One minor issue for RomFS is that the "If unsure, answer Y." text for
ROMFS_BACKED_BY_BLOCK and ROMFS_BACKED_BY_MTD does not really make
much sense given that they are now alternative choices...

Cheers,
FJP
