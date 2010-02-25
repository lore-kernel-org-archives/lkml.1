Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab0BYQbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:31:15 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:37885 "HELO
	outboundproxy6.bluehost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S932186Ab0BYQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:31:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=t/TCnGZadhGUopPm9/3wZcot+8SJa717h9hI0yi/bjvS/5fbAu+iLSuduIdWbBdv6K7Yo+ollAFr/4vmvQDf9ni188wwTL/O05om3w9fNIkoWcu5v22D37/WB3VtrNUK;
Date: Thu, 25 Feb 2010 08:31:26 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [patch] x86: pci: Prevent mmconfig memory corruption
Message-ID: <20100225083126.60379351@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1002251638230.4245@localhost.localdomain>
References: <alpine.LFD.2.00.1002251638230.4245@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010 16:42:11 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> commit ff097ddd4 (x86/PCI: MMCONFIG: manage pci_mmcfg_region as a
> list, not a table) introduced a nasty memory corruption when
> pci_mmcfg_list is empty.
> 
> pci_mmcfg_check_end_bus_number() dereferences pci_mmcfg_list.prev even
> when the list is empty. The following write hits some variable near to
> pci_mmcfg_list.
> 
> Further down a similar problem exists, where cfg->list.next is
> dereferenced unconditionally and a comparison with some variable near
> to pci_mmcfg_list happens.
> 
> Add a check for the last element into the for_each_entry() loop and
> remove all the other crappy logic which is just a leftover of the old
> array based code which was replaced by the list conversion.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: stable@kernel.org
> ---

Applied to my linux-next branch, thanks.  I'll be part of my pull
request to Linus tomorrow.

-- 
Jesse Barnes, Intel Open Source Technology Center
