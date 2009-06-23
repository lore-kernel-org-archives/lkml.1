Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbZFWQ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbZFWQ6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZFWQ6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:58:03 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:57638 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZFWQ6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:58:03 -0400
Date: Tue, 23 Jun 2009 12:57:45 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
Cc: sfi-devel@simplefirmware.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 3/8] SFI: core support
In-reply-to: <87iqin166f.fsf@basil.nowhere.org>
Message-id: <alpine.LFD.2.00.0906231252340.21402@localhost.localdomain>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
 <8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com>
 <87iqin166f.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Andi Kleen wrote:

> Len Brown <lenb@kernel.org> writes:
> 
> > +static ulong __init sfi_early_find_syst(void)
> > +{
> > +	unsigned long i;
> > +	char *pchar = (char *)SFI_SYST_SEARCH_BEGIN;
> > +
> > +	for (i = 0; SFI_SYST_SEARCH_BEGIN + i < SFI_SYST_SEARCH_END; i += 16, pchar += 16) {
> > +		if (!strncmp(SFI_SIG_SYST, pchar, SFI_SIGNATURE_SIZE))
> > +			return SFI_SYST_SEARCH_BEGIN + i;
> 
> 
> Such additional memory scans are always a bit risky, e.g. if there's
> stray hardware there. Has it been verified that existing kernels
> already scan this area?

Yes, SFI is the same as ACPI here (actually, a proper sub-set).

Note that the UEFI folks have suggested that on UEFI systems,
that they hand us the address like they can do for ACPI,
and we'll probably add that at some point.

thanks,
-Len Brown, Intel Open Source Technology Center
