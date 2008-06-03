Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYFCT1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYFCT1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYFCT0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:26:55 -0400
Received: from aun.it.uu.se ([130.238.12.36]:61176 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbYFCT0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:26:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18501.39659.952880.727014@alkaid.it.uu.se>
Date: Tue, 3 Jun 2008 21:26:35 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 broke X on SPARC Ultra5
In-Reply-To: <20080603.062253.17158135.davem@davemloft.net>
References: <18500.62552.958244.633204@harpo.it.uu.se>
	<20080603.062253.17158135.davem@davemloft.net>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:
 > From: Mikael Pettersson <mikpe@it.uu.se>
 > Date: Tue, 3 Jun 2008 09:35:52 +0200
 > 
 > > Fatal server error:
 > > xf86MapPciMem: Could not mmap PCI memory [base=0xe2000000,hostbase=0xe2000000,size=2000] (No such file or directory)
 > > 
 > > I'll start digging through 2.6.25->2.6.26-rc1 later today,
 > > meanwhile I've put Xorg.0.log, Xorg strace, dmesg, and .config
 > > files for 2.6.25 (working) and 2.6.26-rc4 (failing) in
 > > <http://user.it.uu.se/~mikpe/linux/sparc64-2.6.26-rcN-xorg-bug/>.
 > 
 > It's likely this change below.  Unfortunately older versions of X
 > seemingly cannot cope with a lack of PCI host controller in the PCI
 > hierarchy exported by the kernel.
 > 
 > That's really a bug in X, current libpciaccess based X servers work
 > fine, and the bug fixed by this changeset is not solvable in any other
 > reasonable way.  So unfortunately older X verions will stay not
 > working.  Sorry.
 > 
 > commit c26d3c0138970778fabe114df99dffb34a04b1d7
 > Author: David S. Miller <davem@davemloft.net>
 > Date:   Thu May 1 01:12:40 2008 -0700

Confirmed. Reverting this patch from 2.6.26-rc1 made my Xorg-7.1.1 work again.

It's a shame though that a bug fix needs to have such draconian consequences.

/Mikael
