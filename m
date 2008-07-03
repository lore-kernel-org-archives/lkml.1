Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbYGCMBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbYGCMBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbYGCMB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:01:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44387 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbYGCMB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:01:26 -0400
Date: Thu, 3 Jul 2008 05:31:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, michaele@au1.ibm.com,
       linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: Multiple MSI
Message-ID: <20080703113128.GC14894@parisc-linux.org>
References: <20080703024445.GA14894@parisc-linux.org> <1215060119.21182.77.camel@pasglop> <1215067484.17950.35.camel@localhost> <200807031110.30072.arnd@arndb.de> <1215076620.19689.2.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215076620.19689.2.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 07:17:00PM +1000, Benjamin Herrenschmidt wrote:
> > Some years ago, we had discussions about getting rid of IRQ numbers
> > altogether, or at least the requirement to have device drivers know
> > about them. Does anyone remember what happened to that idea?
> 
> I think it's not totally dead. Last I heard, someone (jgarzik ?) was
> slowly, bit by bit, removing the dependencies on the irq argument on irq
> handlers which is one step in the direction.

I think that project's dead, Jim.  http://lkml.org/lkml/2008/4/22/578

> > I think the concept was that you pass around struct irq_desc pointers
> > that may or may not be dynamically allocated by the interrupt controller
> > code.
> 
> Yup. There are still a few hard dependencies on numbers left and right
> tho. The main issue is old userspace tied to the layout of things
> like /proc/interrupts though I'd be happy to special case the 16
> "legacy" interrupts (like we do on powerpc in our remapping layer) and
> only show these here ...

You can't do that.  /proc/interrupts is so terribly useful for a
sysadmin that you can't remove information from it.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
