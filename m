Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZFXAfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZFXAfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZFXAfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:35:23 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:62880 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZFXAfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:35:23 -0400
Date: Tue, 23 Jun 2009 20:35:09 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Justen, Jordan L" <jordan.l.justen@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [SFI-devel] [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI):
 initial support
In-reply-to: <5B8ABB4480AEBB4ABFF06629589B20CD7230EEF8@orsmsx509.amr.corp.intel.com>
Message-id: <alpine.LFD.2.00.0906231959130.32742@localhost.localdomain>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
 <20090623183153.GB12814@srcf.ucam.org>
 <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
 <20090623185120.GA13824@srcf.ucam.org>
 <alpine.LFD.2.00.0906231541400.23079@localhost.localdomain>
 <20090623202302.GA15265@srcf.ucam.org> <20090623204524.GA15891@srcf.ucam.org>
 <alpine.LFD.2.00.0906231734170.32098@localhost.localdomain>
 <5B8ABB4480AEBB4ABFF06629589B20CD7230EEF8@orsmsx509.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Justen, Jordan L wrote:

> > Should a platform require them, any and all of the ACPI
> > defined/reserved tables can be accessed on an SFI system
> > if needed.  Today, the PCI MCFG is the only ACPI table
> > implemented in the known universe of SFI systems.
> 
> When for ACPI tables are used in SFI, they retain the common
> ACPI header format, including the OEM Revision, Creator ID and
> Creator Revision fields  unlike the other SFI structure, correct?

Yes.  ACPI tables are real ACPI tables, per their spec.

> Regarding stripping those fields from the SFI structures,
> how much space does it save in a typical system versus if they
> had retained the common header format that ACPI defines?

While we do save 12-bytes per table, I don't think that is material,
even if firmware folks claim they turn backflips to save every byte...

(Though it is sort of snappy that an SFI table with
 a single 64-bit pointer fits exactly into 32-bytes;
 if density were the primary goal, we'd pack everything in the
 system into a single table with one shared header...)

So the motivation to remove unused fields was not part of
an effort to reduce total memory footprint.
They were removed because it was not possible
to justify their existence.

The benefit of the SFI header being a proper sub-set of
the ACPI header is that it allows the SFI-OS to not have a
special case to parse the XSDT.  It is both a valid SFI table
and a valid ACPI table...

However, as I've had to answer this question multiple
times, I'm thinking that it might have been less total effort
to use a table header that was arbitrarliy different
and have a special case for finding the ACPI XSDT:-)

cheers,
-Len Brown, Intel Open Source Technology Center

