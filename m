Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbYHKSjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbYHKSjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYHKSit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:38:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33159 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbYHKSit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:38:49 -0400
Date: Mon, 11 Aug 2008 20:38:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, jeff.chua.linux@gmail.com,
       Glauber Costa <gcosta@redhat.com>
Subject: Re: [PATCH] Resurect proper handling of maxcpus= kernel option
Message-ID: <20080811183814.GA12788@elte.hu>
References: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com> <20080811181642.GS4524@elte.hu> <48A084C8.6050204@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A084C8.6050204@qualcomm.com>
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


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> > This will need some test time on 32-bit as that is where this 
> > represents a material change. ( albeit what matters most is the 
> > maxcpus=1 distinction - and for that nosmp can be used as well to 
> > turn off multi-cpu support altogether. So we could do this in 
> > v2.6.27 as well. )
> 
> So far we got a couple of reports that it works as expected on 32 
> (both laptop and server/desktop).

Yes, but the usecase i'm worried about is when say maxcpus=1 was used to 
_prevent_ an SMP bootup - because the system would not work otherwise.

i guess we want to tickle those systems anyway as that case is not 
supposed to happen (and it can always be totally disabled via nosmp or 
noapic).

So i'm not against your fix/change per se, i just wanted to highlight 
that it has some impact on existing uses of maxcpus that is outside of 
your cpu-hotplug usecase.

	Ingo
