Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYBGPCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYBGPCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYBGPC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:02:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbYBGPCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:02:25 -0500
Date: Thu, 7 Feb 2008 16:01:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document randomize_va_space and CONFIG_COMPAT_BRK (was
	Re: [PATCH 2/2] ASLR: add possibility for more fine-grained tweaking)
Message-ID: <20080207150122.GA10346@elte.hu>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz> <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz> <20080206134959.GA25689@elte.hu> <Pine.LNX.4.64.0802061650230.30955@jikos.suse.cz> <20080206231040.GA6225@elte.hu> <Pine.LNX.4.64.0802071525520.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802071525520.30955@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Thu, 7 Feb 2008, Ingo Molnar wrote:
> 
> > i'm wondering about the following detail: i guess on 64-bit x86 
> > kernels we could default to !CONFIG_COMPAT_BRK? In 1997 there was no 
> > 64-bit x86. Maybe for compat 32-bit binaries we could keep it off, 
> > but always do it for 64-bit binaries.
> 
> So what do you think is proper behavior in situation when 
> CONFIG_COMPAT_BRK=N on 64bit kernel, and 32bit-binary is loaded in 
> 32bit emulation?
> 
> We can either leave the brk as-is, but that is in contradiction to 
> user explictly specifying CONFIG_COMPAT_BRK=N. Is this what you 
> propose?
> 
> Or we can randomize brk start in such situation, but that is the 
> behavior we currently automatically have due to CONFIG_COMPAT_BRK=N, 
> so no change is needed.

thinking about it ... i think we should just keep this simple, and when 
COMPAT_BRK=y then we disable brk randomization globally. If !COMPAT_BRK 
then we do brk randomization globally as well. (and that is probably 
what users want the sysctl to do anyway - users wont necessarily know 
whether the app breakage they want to solve is due to 32-bit or 64-bit.)

	Ingo
