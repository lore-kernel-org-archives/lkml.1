Return-Path: <linux-kernel-owner+w=401wt.eu-S934191AbXKPPQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191AbXKPPQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbXKPPQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:16:00 -0500
Received: from mail.suse.de ([195.135.220.2]:39193 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759341AbXKPPP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:15:59 -0500
To: Philip Mucci <mucci@cs.utk.edu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: perfmon2 merge news
From: Andi Kleen <andi@firstfloor.org>
References: <20071109213829.GC28276@kroah.com>
	<p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com>
	<4739C42F.8030208@redhat.com>
	<20071113175545.GD4319@frankl.hpl.hp.com>
	<53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
	<20071113185924.GA22748@suse.de>
	<20071113120728.4342e7d7.akpm@linux-foundation.org>
	<20071113203645.GA17145@one.firstfloor.org>
	<9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu>
	<20071114015210.GA20365@one.firstfloor.org>
	<A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu>
Date: Fri, 16 Nov 2007 16:15:56 +0100
In-Reply-To: <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu> (Philip Mucci's message of "Fri\, 16 Nov 2007 01\:18\:19 -0800")
Message-ID: <p737ikicjbn.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Mucci <mucci@cs.utk.edu> writes:
>
> Yes, although this has been done before. You've got the list below in
> the previous
> emails which should be considered the absolute minimum.

I didn't see a clear list. 

My impression so far is that you're not quite sure what you want,
otherwise you would be more concrete.

> - A feature which was dropped earlier by Stefane (only to satiate
> LKML), we consider
> very important. Allowing one tomapping of the kernels view of the
> PMD's, allowing
> user-space access to full 64-bit counts, if the architecture
> supports a user-level read instruction.

You mean returning the register number for RDPMC or equivalent
and a way to enable it for ring 3 access? 

I'm considering that an essential feature too. I wasn't aware
it was dropped.

> Getting the counts in a
> couple of dozen cycles
> is ALWAYS a win for us.

Yes it is for everybody. I've been rather questioning if the slow
ways (complicated syscalls) to get the counter information are really 
needed.

> referring to the concept of eventsets. Having multiplexing is
> important.

Why is it important? 

> - Custom sample formats would be considered not often used in our
> community, largely
> because the tools run on all HPC/Linux architectures. PAPI uses the
> default sample
> format which has been sufficient for our needs. However, the lack of
> custom sample
> formats preclude the dev of the specialized tools that access the
> sampling
> hardware as found on the IA64, PPC64, the Barcelona and the SiCortex
> node chip.
> pfmon exports this functionality quite well, and it does get used.

What do you mean with custom sample formats exactly?  What information
do you want in there? And why?

e.g. PEBS and so on pretty much fix the in memory sample format in hardware,
so they only way to get a custom format would be to use a separate buffer.

I can think of one reason why the kernel should add more information
in a separate buffer (log the instruction bytes so that it can
be disassembled and a address histogram be generated using the PEBS
register values), but it is a relatively obscure one and definitely
not a essential feature. Unfortunately it is also hard to implement completely
race-free.

> This is kind of comment that makes the Linux/HPC folks 'somber'. What
> isn't useful, is being dismissive of an entire community that moves a
> heck of a lot of Linux DVD's. 

Sorry, but these kind of non technical BS arguments will just make
you be ignored in mainline Linux lands. They might work if you pay
a lot of money to specific Linux companies (do you?), but here
on linux-kernel you have to convince with purely technical arguments.

-Andi
