Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZH0XTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZH0XTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 19:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZH0XTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 19:19:41 -0400
Received: from outbound-mail-307.bluehost.com ([67.222.53.253]:44367 "HELO
	outbound-mail-307.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751123AbZH0XTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 19:19:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DsLasL+Hx+gHiRMJ+QwbNnr+BYt/f0hD2sxvzy7Nz20fdHbD+VStX6c2RyT0miSNilk5p0p7GJ+RZDUtTchmKWucN6n4M7CKjU8e8T/7vFKoXK2FaOpyJ6C4B+CN3WJk;
Date: Thu, 27 Aug 2009 16:19:29 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Beng Tan <bengtan1@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: (Re)assignment of PCI BARs
Message-ID: <20090827161929.253e001d@jbarnes-g45>
In-Reply-To: <664902dd0908270449x24f3ee12k615540ffe22e5b58@mail.gmail.com>
References: <664902dd0908270449x24f3ee12k615540ffe22e5b58@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 19:49:32 +0800
Beng Tan <bengtan1@gmail.com> wrote:
> The symptom I'm seeing is that the card has BAR 0 unassigned ...
> 
>   Region 0: Memory at <unassigned> (64-bit, prefetchable) [disabled]
> 
> and indeed, the kernel reports this through dmesg ...
> 
> [    6.147093] PCI: Failed to allocate mem resource
> #0:10000000@e0000000 for 0000:0d:00.0
> 
> Full logs are available at:
> 
> http://208.100.55.9/coldboot_20090827/dmesg.txt
> http://208.100.55.9/coldboot_20090827/iomem.txt
> http://208.100.55.9/coldboot_20090827/lspci_vv.txt
> 
> Doesn't the kernel reassign PCI resources if the BIOS doesnt do a good
> enough job? Or is that not the case in my old kernel (2.6.24)?

A newer kernel could help, there have been some resource related fixes
since 2.6.24.

> Is it possible to force a reassignment of the impacted BAR? For
> example, I wrote a small module which wrote to the device's PCI
> configuration registers to explcitly reassign BAR 0 to 0xc00000000
> (and also bit bashed the connecting bridge to do the same) but ... I'm
> not sure if I'm doing it correctly.

There are some PCI calls you can use to assign space, e.g.
pci_bus_alloc_resource, but really the kernel should try to get this
right.  In your case, it looks like the BIOS isn't giving the bus with
your card a large enough window (256M BAR on your card vs. a 2M windows
on the bus).

-- 
Jesse Barnes, Intel Open Source Technology Center
