Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbZD2MjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbZD2MjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZD2Mi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:38:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50720 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZD2Mi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:38:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18936.18732.35199.647196@cargo.ozlabs.ibm.com>
Date: Wed, 29 Apr 2009 22:33:48 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Robert Richter <robert.richter@amd.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/29] x86/perfcounters: rework
	pmc_amd_save_disable_all() and pmc_amd_restore_all()
In-Reply-To: <20090429111159.GJ2373@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
	<1241002046-8832-5-git-send-email-robert.richter@amd.com>
	<1241003260.8021.236.camel@laptop>
	<20090429111159.GJ2373@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> Could we remove the disable-all facility altogether and make the 
> core code NMI-safe? The current approach wont scale on CPUs that 
> dont have global-disable features.
> 
> disable-all was arguably a hack i introduced and which spread too 
> far. Can you see a conceptual need for it?

If you're talking about hw_perf_save_disable / hw_perf_restore, please
don't get rid of those.  I use them to batch up counter enable/disable
operations so I only have to compute the PMU config once for each
batch rather than every time an individual counter is enabled or
disabled.

Paul.
