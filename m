Return-Path: <linux-kernel-owner+w=401wt.eu-S937143AbXHGWvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937143AbXHGWvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbXHGWuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:50:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759013AbXHGWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:50:48 -0400
Date: Tue, 7 Aug 2007 15:49:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       riku.seppala@kymp.net, Andy Whitcroft <apw@shadowen.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
Message-Id: <20070807154911.5fe93b40.akpm@linux-foundation.org>
In-Reply-To: <20070805075307.GA25890@rhun.haifa.ibm.com>
References: <46B3A7BB.9000102@redhat.com>
	<200708041130.42038.ak@suse.de>
	<20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	<200708050140.49590.ak@suse.de>
	<20070805050410.GB4960@rhun.haifa.ibm.com>
	<86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com>
	<20070805075307.GA25890@rhun.haifa.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Aug 2007 10:53:07 +0300
Muli Ben-Yehuda <muli@il.ibm.com> wrote:

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

I am sooooooo tired of this thing.  Andi, someone, can we for heaven's
sake please just get it all sorted out?

I dropped two of Yinghai's patches which conflicted with this, and then
two more which looked like they depended on the dropped ones.
