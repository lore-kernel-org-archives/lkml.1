Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbYGEWi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbYGEWi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 18:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYGEWiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 18:38:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46995 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYGEWiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 18:38:19 -0400
Date: Sat, 5 Jul 2008 16:38:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: Multiple MSI
Message-ID: <20080705223816.GR14894@parisc-linux.org>
References: <20080703024445.GA14894@parisc-linux.org> <20080705132728.GO14894@parisc-linux.org> <20080705134342.GP14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080705134342.GP14894@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 07:43:42AM -0600, Matthew Wilcox wrote:
> On Sat, Jul 05, 2008 at 07:27:28AM -0600, Matthew Wilcox wrote:
> > Here's some code.  It's four patches, the first two are to the PCI MSI
> > code, the third is for the AHCI driver and the fourth is for the x86-64
> > interrupt code.
> > 
> > It's had some light testing; no performance testing yet.  I'd value some
> > review.
> 
> It's taking a while to come through ... patches are also at:
> 
> http://www.parisc-linux.org/~willy/multiple-msi/
> 
> I'll put up the git tree if there's demand.

I found and fixed a couple of bugs ... and implemented CPU affinity.
As the comment says, when you move one MSI, you move them all (at least
as far as I can figure out the x86 APIC architecture ... other
architectures may not have this problem).  Git tree now available:

git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git multiple-msi
(will be updated as and when)

git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git multiple-msi-20080705
(semi-permanent)

I don't intend to submit these patches to Linus myself; I'd like the
first two to go in through the PCI tree.  The third patch does depend on
the first two, but should go in through the IDE tree.  The fourth patch
is entirely independent of the first three and can go in through the x86
tree at any time.

I love these cross-responsibility patch sets ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
