Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbXLREpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbXLREpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXLREpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:45:08 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34687 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXLREpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:45:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@muc.de>
Cc: venkatesh.pallipadi@intel.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
References: <20071213235543.568682000@intel.com>
	<20071213235711.464325000@intel.com>
	<m1d4taq6le.fsf@ebiederm.dsl.xmission.com>
	<20071214102535.GB9705@muc.de>
Date: Mon, 17 Dec 2007 21:42:41 -0700
In-Reply-To: <20071214102535.GB9705@muc.de> (Andi Kleen's message of "14 Dec
	2007 11:25:35 +0100, Fri, 14 Dec 2007 11:25:35 +0100")
Message-ID: <m163ywd35q.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@muc.de> writes:

>> I do know we need to use the low 4 pat mappings to avoid most of the PAT
>> errata issues.
>
> They don't really matter. These are all very old systems who have run 
> fine for many years without PAT. It is no problem to let them
> continue to do so and just disable PAT for them. So just clear pat bit in
> CPU initialization for any CPUs with non trivial erratas in this
> area.
>
> PAT is only really needed on modern boxes.
>
> Just someone needs to go through the old errata sheets and find
> out on which CPUs it is needed to clear the bit.

It has been ages now, but my impression when I wrote the patch that
current cores still had a few outstanding errata with using the
extended pat bits.

Further it was my impression was that if we just changed UC- to WC
we work on essentially everything, because PAT is always enabled
on the cores that support it.

Therefore since we only have 3 interesting caching modes.
WB, WC, UC.  We should be very careful about reprogramming it
and we can ignore the errors.

As for the pat class errata about inconsistent mappings those are
reoccurring issues, that happen across all cpu types (x86/ppc/fred),
and every  major core overhaul is likely to have them again.

Eric
