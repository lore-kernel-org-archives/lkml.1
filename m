Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbYBNXPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbYBNXPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYBNXPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:15:03 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48614 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755904AbYBNXPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:15:01 -0500
Date: Thu, 14 Feb 2008 15:14:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <alpine.LFD.1.00.0802141456370.6110@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802141503470.6110@woody.linux-foundation.org>
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802141401.24723.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802141323130.6110@woody.linux-foundation.org> <200802141528.53446.bjorn.helgaas@hp.com>
 <alpine.LFD.1.00.0802141456370.6110@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Feb 2008, Linus Torvalds wrote:
> 
> It should insert the resource to the root resource (or a bridge resource), 
> or not at all. If somebody else has already inserted a real device 
> resource, we already know about it, and the PnP information is going to be 
> just making things worse.

Hmm. The approach I'd take is to always insert the thing into the root 
resource. If we do want to let PnP insert it into some lower-level bus, 
we'd need to have some way to distinguish "bus" from "device", and we 
don't.

So right now, how about just making PnP/ACPI just use

	root = (flags & IORESOURCE_MEM) ? iomem_resource : ioport_resource;
	request_resource(root, newresource);

which is what we do for the e820 map and the other special resources we 
know about (ie the magic resources we make up ourselves like video ram and 
our standard PCI/ISA resource lists like the <0x100 DMA/PIC/FPU IO ports 
etc)

		Linus
