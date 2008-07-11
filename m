Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYGKVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYGKVQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYGKVQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:16:03 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43711 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYGKVQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:16:01 -0400
Date: Fri, 11 Jul 2008 15:16:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
Subject: Multiple MSI, take 4
Message-ID: <20080711211559.GV14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here we go with take 4.  Changes:

 - Check the requested number of interrupts against the maximum number
   the device claims to support.  Thanks to Hidetoshi Seto for pointing
   out this oversight.
 - Implemented Eric's suggestion of using a single IRQ and storing the
   data with it.
 - As a result, don't try to support the mode in the AHCI driver where
   the excess ports all share the last interrupt.  It could be done, but
   it would be rather messy and I don't have hardware that supports that
   mode anyway.

I'm fairly comfortable with the subchannel notion we're introducing
here.  It's more flexible than MSI and doesn't impose a penalty on
architectures which don't implement it.  It makes some things more
complex, but it makes other things simpler, so I think it's a wash from
a cleanliness standpoint.

Git tree still at 
git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git multiple-msi
(and this push specifically at multiple-msi-20080711)

Patches to follow.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
