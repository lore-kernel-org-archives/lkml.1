Return-Path: <linux-kernel-owner+w=401wt.eu-S1031571AbXEDVGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031571AbXEDVGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031707AbXEDVGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:06:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:54980 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031571AbXEDVGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:06:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,494,1170662400"; 
   d="scan'208";a="224458676"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Fri, 4 May 2007 14:06:59 -0700
User-Agent: KMail/1.9.6
Cc: Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <4639229C.4030208@shaw.ca> <200705021654.23730.jbarnes@virtuousgeek.org>
In-Reply-To: <200705021654.23730.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041406.59584.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 2, 2007 4:54 pm Jesse Barnes wrote:
> > What happens if you take out the chipset register detection, does
> > the MCFG table give you the same result? Wonder if they're doing
> > something funny with start/end bus values or something in their
> > table. There's some code in my patch that prints out the important
> > data from the MCFG table, can you tell me what that shows with the
> > chipset detection taken out?
>
> Yeah, I'll look a little more closely.  It could also be that another
> register needs tweaking somewhere to actually get the bridge to
> decode the space.
>
> > If that doesn't provide any useful information, I think we may need
> > some assistance from Intel chipset/motherboard people to figure out
> > what is going on here..
>
> I'm talking with them now, hopefully they'll shed some light on it.

I did a little more debugging this morning, and found that I can 
actually do reads from the space described by ACPI and the device 
register, but later when ACPI actually scans the root bridges, it 
hangs.  Specifically the call to pci_acpi_scan_root in 
pci_root.c:acpi_pci_root_add() never seems to return.

I'll walk through that logic when I get back to my test box, but it's 
also worth noting that Vista's MCFG on this machine apparently works ok 
too.

Jesse
