Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYGXJ0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYGXJ0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYGXJ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:26:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56876 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYGXJ0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:26:08 -0400
Date: Thu, 24 Jul 2008 11:25:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: w@1wt.eu, davem@davemloft.net, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi
Subject: Re: [TCP bug, regression] stuck distcc connections in latest -git
Message-ID: <20080724092517.GA31358@elte.hu>
References: <20080724060448.GA10203@elte.hu> <E1KLwlD-0001Ub-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KLwlD-0001Ub-00@gondolin.me.apana.org.au>
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


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> >
> > the client (running 2.6.24) does periodic 120 seconds retransmits:
> > 
> > 07:40:48.255452 IP dione.39201 > phoenix.distcc: . 1608:2144(536) ack 1 win 584007:40:48.255547 IP phoenix.distcc > dione.39201: . ack 2144 win 65535
> > 07:40:48.255564 IP dione.39201 > phoenix.distcc: . 67143:67679(536) ack 1 win 5840
> > 07:40:48.255648 IP phoenix.distcc > dione.39201: . ack 2144 win 65535
> > 07:42:48.255440 IP dione.39201 > phoenix.distcc: . 2144:2680(536) ack 1 win 5840
> > 07:42:48.255559 IP phoenix.distcc > dione.39201: . ack 2680 win 65535
> > 07:42:48.255570 IP dione.39201 > phoenix.distcc: . 67679:68215(536) ack 1 win 5840
> > 07:42:48.255659 IP phoenix.distcc > dione.39201: . ack 2680 win 65535
> > 07:44:48.255436 IP dione.39201 > phoenix.distcc: . 2680:3216(536) ack 1 win 584007:44:48.255570 IP phoenix.distcc > dione.39201: . ack 3216 win 65535
> > 07:44:48.255585 IP dione.39201 > phoenix.distcc: . 68215:68751(536) ack 1 win 5840
> > 07:44:48.255669 IP phoenix.distcc > dione.39201: . ack 3216 win 65535
> 
> OK, something's seriously screwed up on dione's kernel.  Could you 
> please disable syncookies (which should enable SACK for you) and see 
> if the problem goes away?
> 
> I think our Reno code may have been broken.

ok, i've booted the latest kernel on dione and the builds are running on 
it now. It's using these settings currently:

 # cat /proc/sys/net/ipv4/tcp_syncookies
 0
 # cat /proc/sys/net/ipv4/tcp_sack
 1

Just to make sure i have the right test-plan: assuming this 
suspected-good kernel is trouble-free for say 48 hours, i should be able 
to switch back to the suspected-broken variant, by doing:

   echo 1 > /proc/sys/net/ipv4/tcp_syncookies

without rebooting the kernel, right? And then if the bug comes back 
again we've nailed it down to the area you suspect, correct?

	Ingo
