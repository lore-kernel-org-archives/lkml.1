Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZGHRsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZGHRsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZGHRs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:48:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52340 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbZGHRsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:48:25 -0400
Date: Wed, 8 Jul 2009 19:47:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com, davidel@xmailserver.org
Subject: Re: [PATCHv5 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090708174748.GB4650@jolsa.lab.eng.brq.redhat.com>
References: <20090703092438.GE3902@elte.hu> <20090703095659.GA4518@jolsa.lab.eng.brq.redhat.com> <20090703102530.GD32128@elte.hu> <20090703111848.GA10267@jolsa.lab.eng.brq.redhat.com> <20090707101816.GA6619@jolsa.lab.eng.brq.redhat.com> <20090707134601.GB6619@jolsa.lab.eng.brq.redhat.com> <20090707140135.GA5506@Krystal> <4A535EB9.2020406@gmail.com> <20090707145710.GB7124@Krystal> <4A536866.1050906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A536866.1050906@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 05:23:18PM +0200, Eric Dumazet wrote:
> Mathieu Desnoyers a écrit :
> 
> > But read_lock + smp_mb__after_lock + read_unlock is not well suited for
> > powerpc, arm, mips and probably others where there is an explicit memory
> > barrier at the end of the read lock primitive.
> > 
> > One thing that would be efficient for all architectures is to create a
> > locking primitive that contains the smp_mb, e.g.:
> > 
> > read_lock_smp_mb()
> > 
> > which would act as a read_lock which does a full smp_mb after the lock
> > is taken.
> > 
> > The naming may be a bit odd, better ideas are welcome.
> 
> I see your point now, thanks for your patience.
> 
> Jiri, I think your first patch can be applied (including the full smp_mb()),
>  then we will optimize both for x86 and other arches, when all 
> arch maintainers have a chance to change
> "read_lock();smp_mb()" to a faster "read_lock_mb()" or something :)
>

great, I saw you Signed-off the 1/2 part.. could I leave it,
or do I need to resend as a single patch?

jirka
