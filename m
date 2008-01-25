Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbYAYI4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbYAYI4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756311AbYAYI4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:56:34 -0500
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:52502 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbYAYI4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:56:33 -0500
X-Greylist: delayed 4792 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 03:56:33 EST
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Fri, 25 Jan 2008 07:36:42 +0000
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
CC: Matt Mackall <mpm@selenic.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>
Message-ID: <C3BF420A.12CFE%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: [PATCH UPDATE] x86: ignore spurious faults
Thread-Index: AchfJQc+RasJYssYEdyw+AAWy6hiGQ==
In-Reply-To: <47992CB2.8050606@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/1/08 00:26, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

>> I (obviously) don't know exactly how the TLB works in x86, but I
>> thought that on a miss, the CPU walks the pagetables first before
>> faulting? Maybe that's not the case if there is an RO entry
>> actually in the TLB?
>>   
> 
> My understanding is that it will fault immediately if there's a TLB
> entry, and rewalk the tables on return from the fault before restarting
> the instruction, so there's no need for an explicit TLB flush.  The TLB
> doesn't have a notion of negative cache entries, so any entry represents
> a present page of some variety.

Yes, write access with a r/o TLB entry causes the TLB entry to be flushed
and an immediate #PF with no page walk. This is a hardware optimisation for
copy-on-write demand faults. Both Intel and AMD implement it.

 -- Keir


