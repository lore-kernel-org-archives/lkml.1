Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbZKYAoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbZKYAoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933541AbZKYAoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:44:03 -0500
Received: from ozlabs.org ([203.10.76.45]:47780 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933455AbZKYAoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:44:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19212.22371.633313.129961@cargo.ozlabs.ibm.com>
Date: Wed, 25 Nov 2009 09:00:03 +1100
From: Paul Mackerras <paulus@samba.org>
To: eranian@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, perfmon2-devel@lists.sf.net, eranian@google.com
Subject: Re: [PATCH] perf_events: fix validate_event bug
In-Reply-To: <7c86c4470911240518qe0c3e87k589437ef43f4a3d4@mail.gmail.com>
References: <1256223091-6002-1-git-send-email-eranian@gmail.com>
	<1258562785.3918.685.camel@laptop>
	<7c86c4470911230534i4119734k1478550567852220@mail.gmail.com>
	<1258983953.4531.456.camel@laptop>
	<7c86c4470911240518qe0c3e87k589437ef43f4a3d4@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stephane eranian writes:

> That means we can drop is_software_event() in this code and instead
> define locally
> in x86 a is_hw_pmu_event() function as event->pmu == &pmu.

I'd have to see the patch, but that doesn't feel entirely right,
because there is a unique characteristic of software events, compared
to hardware or breakpoint events: they are never capacity
constrained.  In the past, only hardware events were capacity
constrained, which meant that all the decisions about whether a group
could go on could be done in the hardware PMU backend.  Now we have
two sources of capacity constraints, so it may be that a group can't
go on even if the hardware PMU has capacity.  That's going to be
somewhat interesting to get completely right, I think.

Paul.
