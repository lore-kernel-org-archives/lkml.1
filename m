Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZFWUpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZFWUpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZFWUpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:45:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57800 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZFWUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:45:31 -0400
Date: Tue, 23 Jun 2009 21:45:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial
	support
Message-ID: <20090623204524.GA15891@srcf.ucam.org>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org> <20090623183153.GB12814@srcf.ucam.org> <alpine.LFD.2.00.0906231438190.23079@localhost.localdomain> <20090623185120.GA13824@srcf.ucam.org> <alpine.LFD.2.00.0906231541400.23079@localhost.localdomain> <20090623202302.GA15265@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623202302.GA15265@srcf.ucam.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I've got a clearer understanding of my objections to this now. 
The first is that SFI is designed to support the subset of information 
that's in ACPI and which can't be intuited by the OS. However, that 
subset is predicated on the system looking like Moorestown. A system 
that wants to provide any information beyond that subset can't use SFI 
unless it defines additional tables.

And that brings me onto my second issue. ACPI is sufficiently 
generalised that there's little need for vendors to add additional 
tables. SFI isn't, and so vendor adoption is going to require 
vendor-specific tables. This potentially results in SFI bloating out to 
cover much of the functionality of ACPI, while at the same time turning 
into a namespacing nightmare. Without a formal process for adding new 
tables and without any kind of certification requirements before 
claiming SFI compatibility, we're looking at a real risk of collisions.

SFI appears to be presented as a generic firmware interface, but in 
reality it's currently tightly wed to Moorestown and I don't see any way 
that that can be fixed without reinventing chunks of ACPI. I'm certainly 
not enthusiastic about seeing this presented as a fait accompli in 
generic driver code, rather than under arch/x86/moorestown.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
