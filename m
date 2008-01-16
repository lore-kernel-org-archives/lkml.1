Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbYAPENw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbYAPENw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 23:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYAPENo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 23:13:44 -0500
Received: from mx1.suse.de ([195.135.220.2]:49042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbYAPENn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 23:13:43 -0500
To: Pete Wyckoff <pw@osc.edu>
Cc: dean gaudet <dean@arctic.org>, linux-kernel@vger.kernel.org
Subject: Re: nosmp/maxcpus=0 or 1 -> TSC unstable
From: Andi Kleen <andi@firstfloor.org>
References: <alpine.DEB.0.999999.0801121142370.11727@twinlark.arctic.org>
	<20080115225039.GA25701@osc.edu>
Date: Wed, 16 Jan 2008 05:13:41 +0100
In-Reply-To: <20080115225039.GA25701@osc.edu> (Pete Wyckoff's message of "Tue\, 15 Jan 2008 17\:50\:39 -0500")
Message-ID: <p73prw2l85m.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Wyckoff <pw@osc.edu> writes:

> We've seen the same problem.  We use gettimeofday() for timing of
> network-ish operations on the order of 10-50 us.  But not having
> the TSC makes gettimeofday() itself very slow, on the order of 30 us.
>
> Here's what we've been using for quite a few kernel versions.  I've
> not tried to submit it for fear that it could break some other
> scenario, as you suggest.  Although in hotplug scenarios, this
> function unsynchronized_tsc() should get rerun and disable TSC if
> more processors arrive.
>
> At least count this as a "me too".

The patch is wrong of course because when this is checked not 
all CPUs are booted yet. So it will always use TSC even when
multiple CPUs are going to be booted.

The right fix for Dean's problem would be probably to add a new 
parameter that disables CPU hotplug and forces smp_possible_map
to max_cpus, which could then be set with maxcpus=1 (or similar) 

I would not recommend to use nosmp or maxcpus=0 either because it will
disable the APIC and that is typically a bad thing (especially if you
need network performance) 

-Andi
