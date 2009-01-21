Return-Path: <linux-kernel-owner+w=401wt.eu-S1763511AbZAUECv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763511AbZAUECv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 23:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZAUECk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 23:02:40 -0500
Received: from smtp-out.google.com ([216.239.33.17]:1201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbZAUECj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 23:02:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=S7GBD6vhMHKfQ48VuDDNnyuTTLSLT9p4j6b8uvXlz5fHEwBmFb5fQDbQSG3mNcHUR
	/u72fIpHi5gLk09dqwEvg==
MIME-Version: 1.0
In-Reply-To: <497698E2.7090807@rtr.ca>
References: <4975F5C1.8090107@rtr.ca>
	 <alpine.LNX.1.00.0901201626090.19665@iabervon.org>
	 <497698E2.7090807@rtr.ca>
Date: Tue, 20 Jan 2009 20:02:33 -0800
Message-ID: <da824cf30901202002g52fb73f9v8229fb702dcd033d@mail.gmail.com>
Subject: Re: libata, devm_*, and MSI ?
From: Grant Grundler <grundler@google.com>
To: Mark Lord <liml@rtr.ca>
Cc: Daniel Barkalow <barkalow@iabervon.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.143
X-GMailtapped: grundler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 7:39 PM, Mark Lord <liml@rtr.ca> wrote:
...
> Next.. who knows something about debugging MSI across PCI bridges ?
> I've got a 64-bit box here, PCIe near the core, but with full PCI-X
> slots on the far side of two bridges.
>
> The kernel happily allows my driver to setup MSI, but the interrupts
> never arrive.  So something somewhere in between is either
>
> (1) not set up or quirked quite right, or
> (2) one of the bridges won't pass MSI and we don't detect that.
>
> I'll poke more at it later and post some info, if somebody out there
> knows enough about this kind of thing to provide some basic hints.


Basic Hints:
1) post lspci -v output to verify device (and bridges) is programmed correctly.
2) look for chipset quirks that disable global msi
3) Make sure MMIO ranges for 0xfee00000 are routed to local APIC
   ie each bridge needs to route that address somehow (negative decode
is common for upstream).
4) manually trigger the MSI by doing a MMIO write to the correct
0xfee00000 address with the assigned vector in order to see if your
interrupt handler gets called.

After that, it's about collecting PCI-X or PCIe traces to verify the
device is generating the transactions correctly and the bridges are
forwarding them.

hth,
grant
