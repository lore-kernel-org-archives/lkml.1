Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbZGCHu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbZGCHu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZGCHuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:50:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbZGCHuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:50:16 -0400
Date: Fri, 3 Jul 2009 09:50:14 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com, htejun@gmail.com,
       jarkao2@gmail.com, oleg@redhat.com
Subject: Re: [PATCHv4 2/2] memory barrier: adding smp_mb__after_lock
Message-ID: <20090703075014.GC2902@jolsa.lab.eng.brq.redhat.com>
References: <20090702063259.GA3429@jolsa.lab.eng.brq.redhat.com> <20090702063624.GC3429@jolsa.lab.eng.brq.redhat.com> <4A4C5983.7000501@gmail.com> <alpine.DEB.1.10.0907020738020.5194@makko.or.mcafeemobile.com> <20090703074126.GB2902@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090703074126.GB2902@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 09:41:26AM +0200, Jiri Olsa wrote:
> On Thu, Jul 02, 2009 at 07:39:04AM -0700, Davide Libenzi wrote:
> > On Thu, 2 Jul 2009, Eric Dumazet wrote:
> > 
> > > Jiri Olsa a écrit :
> > > > Adding smp_mb__after_lock define to be used as a smp_mb call after
> > > > a lock.  
> > > > 
> > > > Making it nop for x86, since {read|write|spin}_lock() on x86 are 
> > > > full memory barriers.
> > > > 
> > > > wbr,
> > > > jirka
> > > > 
> > > > 
> > > > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > > 
> > > 
> > > Maybe we should remind that sk_has_helper() is always called
> > > right after a call to read_lock() as in :
> > > 
> > > 	read_lock(&sk->sk_callback_lock);
> > > 	if (sk_has_sleeper(sk))
> > > 		wake_up_interruptible_all(sk->sk_sleep);
> > 
> > Agreed, that'd be to have it in the source code comment.
> > 
> > 
> > - Davide
> > 
> 
> ok, I'll add it to the 1/2 part in v5
> 
> jirka

actually I see the 2/2 would be better :)

jirka
