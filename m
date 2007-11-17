Return-Path: <linux-kernel-owner+w=401wt.eu-S1765128AbXKQSmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765128AbXKQSmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759769AbXKQSmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:42:38 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55556 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759143AbXKQSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:42:37 -0500
Date: Sat, 17 Nov 2007 19:40:30 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Kai Ruhnau <kai@tragetaschen.dyndns.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Bogus PCI vendor ID
Message-ID: <20071117184030.GA5541@electric-eye.fr.zoreil.com>
References: <473F0FE0.3010501@tragetaschen.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473F0FE0.3010501@tragetaschen.dyndns.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kai Ruhnau <kai@tragetaschen.dyndns.org> :
[...]
> I have a problem with two of my PCI devices showing the wrong PCI vendor
> ID (0001) in vanilla kernels.
>
> My system currently runs a 32 bit x86 kernel built from ubuntu sources
> 2.6.20.3-ubuntu1. This is the only kernel I have found so far that shows
> the correct PCI IDs:
> 
> ~ # lspci -n
> 00:00.0 0600: 1002:7930
> 00:02.0 0604: 1002:7933
> 00:06.0 0604: 1002:7936
> 00:12.0 0106: 1002:4380
> 00:13.0 0c03: 1002:4387
> 00:13.1 0c03: 1002:4388
> 00:13.2 0c03: 1002:4389
> 00:13.3 0c03: 1002:438a
> 00:13.4 0c03: 1002:438b
> 00:13.5 0c03: 1002:4386
> 00:14.0 0c05: 1002:4385 (rev 13)
> 00:14.1 0101: 1002:438c
> 00:14.2 0403: 1002:4383
> 00:14.3 0601: 1002:438d
> 00:14.4 0604: 1002:4384
> 01:00.0 0300: 10de:0193 (rev a2)
> 02:00.0 0200: 11ab:4364 (rev 12)
> 03:02.0 0c00: 104c:8024
> 
> I tested several vanilla kernels: 2.6.23.1, 2.6.23, 2.6.22, 2.6.21 and
> somewhere between 2.6.20 and 2.6.21 via bisect. There, the output of
> lspci is as follows:
> 
> ~ # lspci -n
[snip]
> 00:14.4 0604: 1002:4384
> 01:00.0 0300: 0001:0193 (rev a2)
> 02:00.0 0200: 0001:4364 (rev 12)
> 03:02.0 0c00: 104c:8024
> 
> Note the two vendor IDs 0001 for 01:00.0 and 02:00.0.
> 
> Since these two devices are my graphics card (PCI express) and network
> card (builtin) respectively I have quite some trouble running my system
> without the right vendor IDs ;-)
> Can this be fixed ?

No idea but it seems to be plaguing us:

- sky2

Kai Ruhnau <kai@tragetaschen.dyndns.org>
[...]
> However, I just booted 2.6.23.1 and additionally checked the output of
> lspci against that from 2.6.20-ubuntu.
> Between both versions the vendor code of my networke device changes from
> 11ab to 0001. Why that?

- r8169 + Abit fatal1ty motherboard

(so far nobody reported a 8169 on a fatal1ty motherboard with a
sensible vendor id)

Josh Logan <joshtlogan@gmail.com>
[...]
> 2.6.20 and above, maybe .18 or .19.
>
> I have never seen the card recognized by a stock kernel.

Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
[...]
> I've used 2.6.21.6 and 2.6.24-rc1, both gave 0x0001. I just tried
> 2.6.18.8 as well, still 0x0001. With earlier kernels my SATA devices

-- 
Ueimor
