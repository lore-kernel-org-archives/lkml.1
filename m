Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbXHEIuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbXHEIuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 04:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbXHEIt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 04:49:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:26121 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbXHEIt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 04:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WRnMJxyWDr6/wdSj8V7PpafYpg2uD3nbjfIOsorhEzUFuIFkP7xkteea8xQ2MXBurdncrAlSIMS1o1LexpLthoHztM4mKM1iitxsbbNFTG3dpKZMZLjxIP9BzRW6oQRujbokRZkLWe1dww41hlgYPV7MAXpTdNaH6yhzl/KodOU=
Message-ID: <86802c440708050149u4c0ef4d8j7ea3478b07312525@mail.gmail.com>
Date: Sun, 5 Aug 2007 01:49:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Muli Ben-Yehuda" <muli@il.ibm.com>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       riku.seppala@kymp.net, "Andy Whitcroft" <apw@shadowen.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <20070805075307.GA25890@rhun.haifa.ibm.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, Muli Ben-Yehuda <muli@il.ibm.com> wrote:
> This patch finishes the i386 and x86-64 ->sysdata conversion and
> hopefully also fixes Riku's and Andy's observed bugs. It is based on
> Yinghai Lu's and Andy Whitcroft's patches (thanks!) with some changes:
>
> - introduce pci_scan_bus_with_sysdata() and use it instead of
>   pci_scan_bus() where appropriate. pci_scan_bus_with_sysdata() will
>   allocate the sysdata structure and then call pci_scan_bus().
> - always allocate pci_sysdata dynamically. The whole point of this
>   sysdata work is to make it easy to do root-bus specific things
>   (e.g., support PCI domains and IOMMU's). I dislike using a default
>   struct pci_sysdata in some places and a dynamically allocated
>   pci_sysdata elsewhere - the potential for someone indavertantly
>   changing the default structure is too high.
> - this patch only makes the minimal changes necessary, i.e., the NUMA node is
>   always initialized to -1. Patches to do the right thing with regards
>   to the NUMA node can build on top of this (either add a 'node'
>   parameter to pci_scan_bus_with_sysdata() or just update the node
>   when it becomes known).
>
> The patch was compile tested with various configurations (e.g., NUMAQ,
> VISWS) and run-time tested on i386 and x86-64. Unfortunately none of
> my machines exhibited the bugs so caveat emptor.
>
> Andy, could you please see if this fixes the NUMA issues you've seen?
> Riku, does this fix "pci=noacpi" on your laptop?
>
> Comments appreciated. If this looks ok it should go into 2.6.23.
>
> Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chuck Ebbert <cebbert@redhat.com>,
> Cc: riku.seppala@kymp.net
> Cc: Andy Whitcroft <apw@shadowen.org>
> Cc: Jeff Garzik <jeff@garzik.org>
> ---

sounds good.

Can you change
pci_scan_bus_with_sysdata(int busno)
to
pci_scan_bus_on_node(int bus, struct pci_ops *ops, int node)?

pci_scan_bus_with_sysdata(int busno) make me feel that i need feed one
sysdata as on param for it.

I only need to update irq.c and legacy.c in my patch.

YH
