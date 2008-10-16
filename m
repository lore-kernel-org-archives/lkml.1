Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYJPTb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYJPTb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbYJPTbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:31:47 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:35550 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbYJPTbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:31:46 -0400
Date: Thu, 16 Oct 2008 15:31:38 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: RE: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code
 ordering
In-reply-to: <C075D3D77BA5EF4FBB0939047B182ABF25C79ADA45@GVW1144EXB.americas.hpqcorp.net>
X-X-Sender: lenb@localhost.localdomain
To: "Brown, John M (WGBU R&D)" <john.brown3@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0810161525450.3026@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200810142254.07024.rjw@sisk.pl>
 <C075D3D77BA5EF4FBB0939047B182ABF25C79AD3EE@GVW1144EXB.americas.hpqcorp.net>
 <alpine.LFD.1.10.0810151746460.3026@localhost.localdomain>
 <200810160001.00053.rjw@sisk.pl>
 <C075D3D77BA5EF4FBB0939047B182ABF25C79ADA45@GVW1144EXB.americas.hpqcorp.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I also noted that acpidump printed this message to stderr:
> Wrong checksum for FADT!

The RSDT has a pointer to an FACP at DEFC2014 (aka FADT),
and that FACP has a bad checksum.

But this system has an XSDT, which the OS prefers
over the RSDT.  The XSDT points to an FACP at DEFC2088
and its checksum is fine.

This difference is moot here,
because both FACP's point to the same DSDT at DEFC2647,
and it is the DSDT that has the AML related to ordering.

The reason you see this error message from acpidump
and not from Linux is that the kernel only uses the 'active' 
tables, while acpidump snags both the active and insactive tables
for debugging.

cheers,
-Len

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Wednesday, October 15, 2008 4:01 PM
> To: Len Brown
> Cc: Brown, John M (WGBU R&D); Matthew Garrett; ACPI Devel Maling List; Andrew Morton; LKML
> Subject: Re: [PATCH] ACPI suspend: Blacklist HP xw4600 Workstation for old code ordering
> 
> On Wednesday, 15 of October 2008, Len Brown wrote:
> > Matthew,
> > You are right, of course, we're not doing something right if a new
> > machine needs this workaround.
> 
> Isn't that possible, however, that the BIOS of this new machine is based on an older one that used to have this problem?
> 
> > However, we don't yet know what we're not doing right:-)
> 
> Well, John, can you please post the output of acpidump from this machine?
> 
> Thanks,
> Rafael
> 
