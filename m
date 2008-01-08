Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbYAHJva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbYAHJva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYAHJvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:51:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32893 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbYAHJvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:51:22 -0500
Date: Tue, 8 Jan 2008 10:50:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] x86, ptrace: add version and last remaining size
	to status command
Message-ID: <20080108095030.GI27671@elte.hu>
References: <20080107133346.A11643@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080107133346.A11643@sedona.ch.intel.com>
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


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Return the API version and the size of a bts_struct in the 
> PTRACE_BTS_STATUS command. This might be handy in case other archs 
> want to use and extend the interface. It allows users to program 
> against one version and continue to work for newer versions (they have 
> to discard everything they don't understand, of course).

i think this will be quite handy. But:

+       /* actual size of bts_struct in bytes */
+       unsigned short bts_size;
+       /* interface version */
+       unsigned short version;

please dont use shorts. Lets just us bts_size and no version at all, ok? 
Any change to the ABI will be extension and that can be done by changing 
the size of the data structure. We try to avoid doing versioned APIs in 
Linux syscalls.

and while at it, how about using u32/u64 for the fields (that's how we 
expose ABIs, even if we know that 'unsigned int' is always 32-bit on 
x86), and add support for COMPAT as well?

	Ingo
