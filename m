Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXIFL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXIFL5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 07:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXIFL5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 07:57:33 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37654 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbXIFL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 07:57:32 -0400
Date: Thu, 6 Sep 2007 05:57:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: [RFC] disable PCIE 'Enable No Snoop' bit by default
Message-ID: <20070906115730.GE14130@parisc-linux.org>
References: <1189056908.24368.9.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1189056908.24368.9.camel@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 01:35:08PM +0800, Shaohua Li wrote:
> PCIE 'Enable No Snoop' bit is set by default per PCIE spec, but OS
> assumes PCI DMA is snooped, which is legacy PCI device does. Enabling no
> snoop might cause potential DMA issues. This patch disables it, if a
> driver can work with no snoop, we can provide a helper to enable it.

I'm not sure your analysis is correct.  Here's what my draft copy of
the pcie 2.0 spec says:

  Enble No Snoop ­ If this bit is Set, the Function is permitted to
  Set the No Snoop bit in the Requester Attributes of transactions it
  initiates that do not require hardware enforced cache coherency (see
  Section 2.2.6.5). Note that setting this bit to 1b should not cause
  a Function to Set the No Snoop attribute on all transactions that it
  initiates. Even when this bit is Set, a Function is only permitted
  to Set the No Snoop attribute on a transaction when it can guarantee
  that the address of the transaction is not stored in any cache in
  the system.  This bit permitted to be hardwired to 0b if a Function
  would never Set the No Snoop attribute in transactions it initiates.
  Default value of this bit is 1b.

That implies that devices are only allowed to set it when it's safe to
do so ... and we don't need to turn it off.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
