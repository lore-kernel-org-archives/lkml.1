Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZGGPYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZGGPYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZGGPXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:23:50 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:50667 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbZGGPXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:23:49 -0400
Message-ID: <4A536866.1050906@gmail.com>
Date: Tue, 07 Jul 2009 17:23:18 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, fbl@redhat.com, nhorman@redhat.com,
       davem@redhat.com, htejun@gmail.com, jarkao2@gmail.com, oleg@redhat.com,
       davidel@xmailserver.org
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
References: <20090703090606.GA3902@elte.hu> <4A4DCD54.1080908@gmail.com> <20090703092438.GE3902@elte.hu> <20090703095659.GA4518@jolsa.lab.eng.brq.redhat.com> <20090703102530.GD32128@elte.hu> <20090703111848.GA10267@jolsa.lab.eng.brq.redhat.com> <20090707101816.GA6619@jolsa.lab.eng.brq.redhat.com> <20090707134601.GB6619@jolsa.lab.eng.brq.redhat.com> <20090707140135.GA5506@Krystal> <4A535EB9.2020406@gmail.com> <20090707145710.GB7124@Krystal>
In-Reply-To: <20090707145710.GB7124@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 07 Jul 2009 17:23:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers a écrit :

> But read_lock + smp_mb__after_lock + read_unlock is not well suited for
> powerpc, arm, mips and probably others where there is an explicit memory
> barrier at the end of the read lock primitive.
> 
> One thing that would be efficient for all architectures is to create a
> locking primitive that contains the smp_mb, e.g.:
> 
> read_lock_smp_mb()
> 
> which would act as a read_lock which does a full smp_mb after the lock
> is taken.
> 
> The naming may be a bit odd, better ideas are welcome.

I see your point now, thanks for your patience.

Jiri, I think your first patch can be applied (including the full smp_mb()),
 then we will optimize both for x86 and other arches, when all 
arch maintainers have a chance to change
"read_lock();smp_mb()" to a faster "read_lock_mb()" or something :)

