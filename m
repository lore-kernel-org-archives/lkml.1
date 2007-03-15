Return-Path: <linux-kernel-owner+w=401wt.eu-S1030367AbXCONA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367AbXCONA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030314AbXCONAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:00:55 -0400
Received: from aun.it.uu.se ([130.238.12.36]:42009 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030196AbXCONAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:00:54 -0400
X-Greylist: delayed 942 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 09:00:54 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17913.16058.137422.920430@alkaid.it.uu.se>
Date: Thu, 15 Mar 2007 13:40:26 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Valerie Henson <val_henson@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Guido Classen <classeng@clagi.de>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 1/4] [TULIP]  fix for Lite-On 82c168 PNIC
In-Reply-To: <20070312095911.430834000@linux.intel.com>
References: <20070312093128.577087000@linux.intel.com>
	<20070312095911.430834000@linux.intel.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valerie Henson writes:
 > From: Guido Classen <classeng@clagi.de>
 > 
 > This small patch fixes two issues with the Lite-On 82c168 PNIC adapters.
 > I've tested it with two cards in different machines both chip rev 17
 > 
 > The first is the wrong register address CSR6 for writing the MII register
 > which instead is 0xB8 (this may get a symbol too?) (see similar exisiting code
 > at line 437) in tulip_core.c
 > 
 > [Double-checked by Val Henson; yes, 0xB8 is correct register for
 > autonegotiate on this card.]
 > 
 > At least by my cards, the the bit 31 from the MII register seems to be
 > somewhat unstable. This results in reading wrong values from the Phy-Registers
 > und prevents the card from correct initialization. I've added a litte delay
 > and an second test of the bit. If the bit is stil cleared the read/write
 > process has definitely finished.
 > 
 > [Original patch slightly massaged by Val Henson]

Your patch doesn't test for rev 17, so it affects all 82c168 chips.

First, I've been using a rev 32 82c168 for years now in a News
server that's up 24/7, without any issues.

Second, I'm now testing your patch on my rev 32 chip, and so far
it seems to not have caused any regressions.

Just FYI.

/Mikael
