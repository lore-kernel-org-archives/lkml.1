Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZHYSQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZHYSQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZHYSQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:16:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40082 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbZHYSQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:16:02 -0400
Date: Tue, 25 Aug 2009 20:15:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Yinghai Lu <yinghai@kernel.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825181500.GB3277@elte.hu>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825171716.GC6456@localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Mon, Aug 24, 2009 at 10:12:01PM -0700, Yinghai Lu wrote:
> >Ravikiran G Thirumalai wrote:
> >> On Mon, Aug 24, 2009 at 04:53:45PM -0700, Yinghai Lu wrote:
> >>> Ravikiran G Thirumalai wrote:
> >>>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> >>>> Cc: Yinghai Lu <yinghai@kernel.org>
> >>>>
> >>>
> >> 
> >> Why?  The specs seem to indicate otherwise unless I am mistaken --
> >> Intel  systems programming guide, Vol 3A Part1, chapter 7 section
> >> 7.5.5 - Identifying Logical Processors in a MP system:
> >> <quote>
> >> After the BIOS has completed the MP initialization protocol, each logical
> >> processor can be uniquely identified by its local APIC ID. Software can
> >> access these APIC IDs in either of the following ways
> >> </quote>
> >> phys_pkg_id() indicates that the logical package id is being looked up,
> >> so local apic id should be used here no?
> >> What am I missing?
> >
> >initial apic id : it can not changed, there is fixed mapping from that to physical processor id aka socket id / node id.
> >
> >apic id: could be changed by BIOS to any value. there is no good way to get phys_pkg_id from that.
> >
> 
> But BIOS is supposed to change it to a sane value.  Until 2.6.30, 
> local apic id has been used to get phys_pkg_id for the 'flat' 
> apics!  What changed?  Was this changed for a BIOS bug?  Even the 
> intel books seem to indicate local apic usage!

We should revert to the .30 behavior unless there's a good reason 
(even in that case we'll solve the regression and do a workaround 
for vSMP). Yinghai?

	Ingo
