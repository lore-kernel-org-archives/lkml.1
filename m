Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbYHEMST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbYHEMST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbYHEMPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:15:35 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:46713 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbYHEMPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:15:34 -0400
Date: Tue, 5 Aug 2008 22:15:32 +1000
From: Simon Horman <horms@verge.net.au>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch] PCI: check the return value of
	device_create_bin_file() in pci_create_bus()
Message-ID: <20080805121531.GA29763@verge.net.au>
References: <20080805101605.GA19382@verge.net.au> <1217932416.7758.4.camel@localhost> <20080805101605.GA19382@verge.net.au> <alpine.LNX.1.10.0808051224350.5671@titan.stealer.net> <20080805110006.GA13409@verge.net.au> <20080805111406.GA13899@verge.net.au> <20080805112814.GO26461@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805112814.GO26461@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 05:28:14AM -0600, Matthew Wilcox wrote:
> On Tue, Aug 05, 2008 at 09:14:07PM +1000, Simon Horman wrote:
> > Check the return value of device_create_bin_file in pci_create_bus,
> > unwind if necessary, and propagate any errors to the caller.
> 
> Yes, but you're essentially saying here that if I can't create a couple
> of poxy sysfs files, I can't have this PCI bus at all?  This seems like
> a bad decision to me.  I'd rather have a PCI bus without the files than
> no PCI bus at all.  By all means, we should whinge mightily if we can't
> create the files so the sysadmin has a chance of figuring out why things
> aren't quite working right, but I might have my root filesystem on a
> device on that PCI bus.

Are you suggesting just making pci_create_bus() have a big winge
using printk() but returning void regardless of what happens?
That sounds fine to me, though I guess it would also need to unwind
if the first call to device_create_bin_file() succeeds but the second
one doesn't.
