Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZDVJX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZDVJX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZDVJXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:23:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbZDVJXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:23:20 -0400
Date: Wed, 22 Apr 2009 11:22:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
Message-ID: <20090422092259.GC18226@elte.hu>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> Re-implement MCE log ring buffer as per-CPU ring buffer for better 
> scalability. Basic design is as follow:

Before changing anything substantial in the MCE code it would be 
necessary to clean up and then unify the 32-bit and 64-bit side of 
the MCE code first. (Which essentially means extending the 
64-bit-only code to 32-bit)

I've put a few cleanup patches into tip:x86/mce2 (warning: there are 
a few broken ones at the tail - so consider it WIP), to help make 
this happen:

 dd98699: x86, mce: print number of MCE banks
 ef319a8: x86, mce: unify
 be0f336: x86, mce: unify, prepare for 32-bit
 90c99b7: x86, mce: prepare unification
 1e1d4f8: x86, mce: prepare mce.h and mce_64.c for unification
 fd6b13f: x86, mce: clean up mce_64.c
 f7f8e03: x86, mce: clean up mce_intel.c
 b19c8ea: x86, mce: unify the Intel thermal interrupt code
 6eade5b: mce: unify Intel thermal init, prepare
 d393769: x86, mce: clean up mce.h
 7bb2efa: x86, mce: clean up winchip.c
 3b94f2b: x86, mce: clean up p5.c
 13a219b: x86, mce: clean up mce_32.c
 e69e307: x86, mce: clean up non-fatal.c
 3b9a5bc: x86, mce: clean up k7.c
 79e1d29: x86, mce: clean up p6.c
 c5fac5b: x86, mce: clean up therm_throt.c
 788a16a: x86, mce: clean up p4.c
 07d7726: x86, mce: clean up mce_amd_64.c
 a6a6958: x86, mce: clean up the sysfs variables namespace
 895f799: x86, mce: clean up the mce_64.c code

these are the more questionable ones in need of restructuring:

 dd98699: x86, mce: print number of MCE banks
 ef319a8: x86, mce: unify
 be0f336: x86, mce: unify, prepare for 32-bit
 90c99b7: x86, mce: prepare unification
 1e1d4f8: x86, mce: prepare mce.h and mce_64.c for unification
 fd6b13f: x86, mce: clean up mce_64.c
 f7f8e03: x86, mce: clean up mce_intel.c
 b19c8ea: x86, mce: unify the Intel thermal interrupt code
 6eade5b: mce: unify Intel thermal init, prepare

... but you get the idea.

	Ingo
