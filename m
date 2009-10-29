Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZJ2Hey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZJ2Hey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbZJ2Hey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:34:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52018 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482AbZJ2Hex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:34:53 -0400
Date: Thu, 29 Oct 2009 08:34:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86, mce: short output of MCE banks ownership
	information
Message-ID: <20091029073408.GA18976@elte.hu>
References: <4AE90E43.2030709@jp.fujitsu.com> <adaaaza6exw.fsf@cisco.com> <4AE93B42.5040605@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE93B42.5040605@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> Maybe there would be more desirable ways, but I think that "compress 
> messages shorter to bear heavy repeating" will be a good way at this 
> time.

We really want to only print out relevant information. 128 lines of 
identical output is not relevant. (or 2x 64 lines, or 4096 lines of 
identical output)

So we only want to print MCE setup messages on the boot CPU. That gives 
us 90% of the benefits already: we see the rough structure of the 
hardware, and if the bootup has a problem with MCE initialization we get 
relevant printouts that helps debugging.

Now, it's certainly true that with things like MCE bank sharing the MCE 
setup output from different CPUs might not be identical all the time - 
but the information is represented in other (topology) info anyway. (and 
if not it wasnt all that important to begin with)

For non-boot CPUs we can perhaps add a mce=verbose (default-disabled) 
mode of bootup that allows all CPUs to be printed - should there be any 
problem with MCE details only visible on non-boot CPUs. (unlikely)

	Ingo
