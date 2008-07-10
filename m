Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYGJWRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYGJWRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 18:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYGJWRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 18:17:36 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:53612 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbYGJWRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 18:17:36 -0400
Date: Fri, 11 Jul 2008 00:17:29 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Marcus Sundberg <marcus@ingate.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26-rc9] r8169: Avoid thrashing PCI conf space on
	RTL_GIGA_MAC_VER_20.
Message-ID: <20080710221729.GB18477@electric-eye.fr.zoreil.com>
References: <48760F22.8040208@ingate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48760F22.8040208@ingate.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Sundberg <marcus@ingate.com> :
> The magic write to register 0x82 will often cause PCI config space on
> my 8168 (PCI ID 10ec:8168, revision 2. mounted in an LG P300 laptop)
> to be filled with ones during driver load, and thus breaking NIC
> operation until reboot. If it does not happen on first driver load it
> can easily be reproduced by unloading and loading the driver a few
> times.

I have added it at the root of the 'r8169' branch in repository:

git://git.kernel.org/pub/scm/linux/kernel/git/romieu/netdev-2.6.git r8169

The branch is described below (on top of davem's 'next' branch).

The whole serie is available as a patck-kit on top of 2.6.26-rc9 at:

http://userweb.kernel.org/~romieu/r8169/2.6.26-rc9/20080710/ 


Diffstat
--------

 drivers/net/r8169.c |  496 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 470 insertions(+), 26 deletions(-)

Shortlog
--------

Francois Romieu (12):
      r8169: update phy init parameters
      r8169: new phy init parameters for the 8168b
      r8169: shuffle some registers handling around (8168 operation only)
      r8169: add 8168 registers description
      r8169: make room for more specific 8168 hardware start procedure
      r8169: Tx performance tweak
      r8169: sync existing 8168 device hardware start sequences with vendor driver
      r8169: add a new 8168 flavor
      r8169: add a new 8168 flavor (bis)
      r8169: add a new 8168 flavor (ter)
      r8169: change default behavior for mildly identified 8168c chipsets
      r8169: use pci_find_capability for the PCI-E features

Marcus Sundberg (1):
      r8169: avoid thrashing PCI conf space above RTL_GIGA_MAC_VER_06

-- 
Ueimor
