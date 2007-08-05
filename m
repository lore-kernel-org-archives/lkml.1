Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbXHEQkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbXHEQkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbXHEQjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:39:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:43706 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803AbXHEQjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lEUW0B6NcTanxnDUwEjJiQfjbAA08JG2DlE1HpDqSsbZjdtx3hOMZWNrwwxUkp0Q120X9SAACNFD34B5zSCx793NoL91hkBdRNVFsVfD5AXVVW21iY7Cve75KHVvslVEx3hyGWhhy05wzXgshsZhDWCyhtv0ne9fGEjDtQbmNVA=
Message-ID: <86802c440708050939t7853ad74w5f039d1478964857@mail.gmail.com>
Date: Sun, 5 Aug 2007 09:39:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       riku.seppala@kymp.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <20070805115457.GD19963@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	 <200708050140.49590.ak@suse.de>
	 <20070805050410.GB4960@rhun.haifa.ibm.com>
	 <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com>
	 <20070805075307.GA25890@rhun.haifa.ibm.com>
	 <86802c440708050149u4c0ef4d8j7ea3478b07312525@mail.gmail.com>
	 <20070805115457.GD19963@rhun.haifa.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> On Sun, Aug 05, 2007 at 01:49:57AM -0700, Yinghai Lu wrote:
>
> > Can you change
> > pci_scan_bus_with_sysdata(int busno)
> > to
> > pci_scan_bus_on_node(int bus, struct pci_ops *ops, int node)?
>
> Do you anticipate passing in a different pci_ops or node?
> In any case please remember I am aiming for the minimal "obviously
> correc" change for 2.6.23...
>
> > pci_scan_bus_with_sysdata(int busno) make me feel that i need feed one
> > sysdata as on param for it.
>
> Yeah, lousy name, but the best I came up with. Runner up was
> 'x86_pci_scan_bus', which is I think worse?
>
or

pci_scan_bus_on_node(int bus, struct pci_ops *ops, int node)
x86_pci_scan_root_bus(int bus)
{
  pci_scan_bus_on_node(bus, &pci_root_ops, -1);
}

i need node as one param for my patch later in irq.c and legacy.c

YH
