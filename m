Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbYBXHWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbYBXHWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 02:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbYBXHWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 02:22:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYBXHWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 02:22:21 -0500
Date: Sun, 24 Feb 2008 08:22:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86,fpu: split FPU state from task struct
Message-ID: <20080224072202.GB655@elte.hu>
References: <20080224023547.264625000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224023547.264625000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Split the FPU save area from the task struct. This allows easy 
> migration of FPU context, and it's generally cleaner. It also allows 
> the following two optimizations:
> 
> 1) only allocate when the application actually uses FPU, so in the 
> first lazy FPU trap. This could save memory for non-fpu using apps. 
> Next patch does this lazy allocation.
> 
> 2) allocate the right size for the actual cpu rather than 512 bytes 
> always. Patches enabling xsave/xrstor support (coming shortly) will 
> take advantage of this.

i like the concept. Please clean up the issues found by Christoph and 
please also base it against x86.git#testing [this is clear 2.6.26 
material and there are already some changes in this area]:

   http://people.redhat.com/mingo/x86.git/README

	Ingo
