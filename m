Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbZFWVeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbZFWVeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759244AbZFWVeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:34:17 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:58816 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961AbZFWVeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:34:15 -0400
Date: Tue, 23 Jun 2009 17:33:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial support
In-reply-to: <20090623202302.GA15265@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.0906231715060.32098@localhost.localdomain>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
 <20090623183153.GB12814@srcf.ucam.org>
 <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
 <20090623185120.GA13824@srcf.ucam.org>
 <alpine.LFD.2.00.0906231541400.23079@localhost.localdomain>
 <20090623202302.GA15265@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Matthew Garrett wrote:

> On Tue, Jun 23, 2009 at 04:00:55PM -0400, Len Brown wrote:
> 
> > But given that the hardware is fixed (it was fixed over a year ago),
> > the question becomes what does ACPI mean on such a platform?
> > It turns out that if you look at the ACPI spec and delete all the
> > things that could not possibly apply to MRST, then you are left
> > with very little.
> 
> Right, but instead you've effectively taken ACPI, done s/XSDT/SYST/ and 
> then only supported a subset of the static tables and added some others.

sfi_acpi_table_parse(ACPI_SIG_MCFG, NULL, NULL, 0, pci_parse_mcfg);

is used today to provide access to a standard PCI-SIG-defined ACPI-wrapped
static MMCONFIG table via a standard ACPI XSDT.

No, this doesn't mean that the platform firmware supports ACPI mode.
The XSDT simply keeps the SFI table name space from conflicting
with the ACPI table name-space.

If there is a need to access another ACPI defined/reserved signature
table, the same mechanism can be used -- just fill in the signature
and the routine to parse the table.

> In return we gain two implementations to debug. I'm absolutely fine with 
> the concept of a cut-down ACPI, but I'm pretty uncomfortable with it 
> being implemented as a single-vendor spec.  Right now SFI's a 
> reimplementation of functionality we already have for the benefit of a 
> single chipset, whereas instead it could have been a refactoring of the 
> ACPI codebase to allow vendors to include whatever subset of the ACPI 
> functionality they felt necessary.

It is a fact that the list of things that SFI could have been,
and the list of things that SFI is not,
are _both_ much larger than the list of things it is.

cheers,
-Len Brown, Intel Open Source Technology Center

