Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbZAMRpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbZAMRpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 12:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZAMRpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 12:45:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42095 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZAMRpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 12:45:41 -0500
Date: Tue, 13 Jan 2009 18:45:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, ying.huang@intel.com
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
Message-ID: <20090113174522.GA26965@elte.hu>
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu> <49594411.60000@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49594411.60000@linux.intel.com>
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


* Andi Kleen <ak@linux.intel.com> wrote:

> Ingo Molnar wrote:
>
>>>> A far more useful design for handling MCE events would be to feed 
>>>> them into printk logging.
>>> If there's ASCII logging it should be separate from normal printk.
>>
>> Well, why? 
>
> Mostly because the problem is not a kernel issue. Especially large 
> systems with a lot of memory can generate a lot of corrected events (one 
> bit flips in DIMMs are not that uncommon) and it's not good to mix that 
> all up into other kernel messages. It also makes it more clear that it's 
> not a kernel problem, but a hardware problem. I've got feedback over the 
> years that confirm this sight.

Is your argument that syslog is not suitable for the logging of hw events?

If that is your argument then the answer is to extend syslog with those 
aspects, instead of widening the quirky /dev based mce ABIs to achieve 
something similar.

If you think that it's suitable then that contradicts your point above.

> [...]
>
> None of the points above are real show stoppers for an ASCII interface, 
> but I think with all of this above together considered it's not really 
> an attractive change.
>
> I think what could be done is:
>
> - Investigate how to make the panic message more information without 
>   adding full decoders.
>
> - Implement the default panic timeout method 
>   described above to get automatic on disk logging in common cases.
>
> Would that address your concerns?

For me the main blocking point is that mcelog uses a quirky, binary 
side-channel instead of using our main ASCII based logging abstraction 
that we have in Linux: printk + syslog.

That is a high level argument, while most of your arguments are low level. 
I dont think you can understand my argument if you concentrate on the low 
level only.

We need to resolve this instead of expanding the broken /dev/mcelog 
interface. If we expand the broken interface first then that removes all 
the incentives to enhance the primary logging facility of Linux in this 
area.

Anyway, this merge window has been very crowded in the x86 space already, 
and the MCE topic is not particularly super-important to have right now 
either, so lets skip it for this cycle so that we have more time to 
cleanly work out these details.

Let me know if there are must-have fixes in it and we can cherry-pick it 
over into x86/urgent.

Thanks,

	Ingo
