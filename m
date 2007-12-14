Return-Path: <linux-kernel-owner+w=401wt.eu-S1763826AbXLNKZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763826AbXLNKZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXLNKZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:25:37 -0500
Received: from colin.muc.de ([193.149.48.1]:3485 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbXLNKZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:25:37 -0500
Date: 14 Dec 2007 11:25:35 +0100
Date: Fri, 14 Dec 2007 11:25:35 +0100
From: Andi Kleen <ak@muc.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: venkatesh.pallipadi@intel.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 02/12] PAT 64b: Basic PAT implementation
Message-ID: <20071214102535.GB9705@muc.de>
References: <20071213235543.568682000@intel.com> <20071213235711.464325000@intel.com> <m1d4taq6le.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4taq6le.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I do know we need to use the low 4 pat mappings to avoid most of the PAT
> errata issues.

They don't really matter. These are all very old systems who have run 
fine for many years without PAT. It is no problem to let them
continue to do so and just disable PAT for them. So just clear pat bit in
CPU initialization for any CPUs with non trivial erratas in this
area.

PAT is only really needed on modern boxes.

Just someone needs to go through the old errata sheets and find
out on which CPUs it is needed to clear the bit.

> As for Andi's concern about modules playing games with the PAT mappings
> if we don't redefine how we use the page table entries our exposure to
> badly behaved modules more limited.

I would just recheck them after module load and if it happens
print a nasty message and program them back. e.g. kernel debuggers
need an after module notifier anyways, so it would be fine
to just add one and hook into that.

-Andi

