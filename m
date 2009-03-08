Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZCHK6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZCHK6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZCHK55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:57:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZCHK54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:57:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] igb: fix kexec with igb
Date: Sun, 8 Mar 2009 11:57:36 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
References: <49B1F934.5050006@kernel.org> <4807377b0903062318q15ba52a7n82d4c9399b8a7fa8@mail.gmail.com> <86802c440903062331j22aa57c7r93c84da880a8e572@mail.gmail.com>
In-Reply-To: <86802c440903062331j22aa57c7r93c84da880a8e572@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903081157.37139.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 March 2009, Yinghai Lu wrote:
> On Fri, Mar 6, 2009 at 11:18 PM, Jesse Brandeburg
> <jesse.brandeburg@gmail.com> wrote:
> > On Fri, Mar 6, 2009 at 8:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >> Impact: could probe igb
> >>
> >> Found one system with 82575EB, in the kernel that is kexeced, probe igb
> >> failed with -2.
> >>
> >> it looks like the same behavior happened on forcedeth.
> >>
> >> try to check system_state to make sure if put it on D3
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>
> >> ---
> >>  drivers/net/igb/igb_main.c |   19 ++++++++++++++-----
> >>  1 file changed, 14 insertions(+), 5 deletions(-)
> >
> > I see the point of the patch, but I know for a fact that ixgbe when
> > enabled for MSI-X also doesn't work with kexec.
> >
> > so my questions are:
> > are you going to change every driver?
> 
> i tend to only change driver that i have related HW.
> 
> > why can't this be fixed in core kernel code instead?
> will check it.
> 
> > Shouldn't pci_enable_device take it out of D3?
> > Or maybe it should be taken out of D3 immediately if someone tries to
> > ioremap any of the BARx registers?
> 
> 
> looks like second kernel can not detect the state any more.

In fact pci_enable_device() calls pci_set_power_state(dev, PCI_D0) as the first
thing.  The question is why it doesn't work as expected.

What kernel(s) have you tested?

Thanks,
Rafael
