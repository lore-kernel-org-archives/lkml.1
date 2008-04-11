Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbYDKKkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbYDKKkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbYDKKk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:40:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54379 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758507AbYDKKk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:40:27 -0400
Date: Fri, 11 Apr 2008 12:40:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080411104015.GA30997@elte.hu>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <Pine.LNX.4.64.0804072348050.26562@twin.jikos.cz> <20080411102548.GO10801@elte.hu> <Pine.LNX.4.64.0804111229020.3896@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804111229020.3896@jikos.suse.cz>
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

> On Fri, 11 Apr 2008, Ingo Molnar wrote:
> 
> > > [ CCs added ]
> > thanks Jiri, i've applied both patches of yours. (let me know if there 
> > are any updated patches) do they solve the problem?
> 
> Hi Ingo,
> 
> thanks, but I don't think they are the proper fix anymore. We'd rather 
> figure out why interrupts were enabled in the first place while the 
> code was running.
> 
> Which is quite difficult, because Zdenek doesn't seem to be able to 
> reproduce it, so we even don't know whether it has been caused by KVM 
> or not.

if sticking a WARN_ON_ONCE(!irqs_disabled()) somewhere would help in 
making the breakage more visible i'd be glad to apply such a patch.

	Ingo
