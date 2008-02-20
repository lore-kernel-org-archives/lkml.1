Return-Path: <linux-kernel-owner+w=401wt.eu-S1758882AbYBTIMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbYBTIMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYBTIMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:12:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYBTIMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:12:39 -0500
Date: Wed, 20 Feb 2008 09:12:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Message-ID: <20080220081228.GA27036@elte.hu>
References: <20080213.050340.64342037.davem@davemloft.net> <12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com> <20080213.170452.68851396.davem@davemloft.net> <12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com> <adaprv0rygh.fsf@cisco.com> <12c511ca0802141327j6e31e8c2tee1d679053b604fc@mail.gmail.com> <ada7ih7qjoq.fsf@cisco.com> <1FE6DD409037234FAB833C420AA843EC97C8B0@orsmsx424.amr.corp.intel.com> <12c511ca0802141817i3295e83cxd7c05e07f2c54fea@mail.gmail.com> <12c511ca0802191440q6a2f5604xe6b563c32c3a90b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12c511ca0802191440q6a2f5604xe6b563c32c3a90b2@mail.gmail.com>
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


* Tony Luck <tony.luck@gmail.com> wrote:

> > Perhaps what is happening is that cpu0 comes online ... safely skips 
> > over the early printk calls.  Calls cpu_init() which sets up the 
> > resources *it* needs (ar.k3 points to per-cpu space), and then 
> > executes sched_init() which marks it safe for all printk's. Then 
> > cpu1 comes up and does a printk before it gets to cpu_init().
> 
> I just tried Ingo's patch[1] on a 2.6.25-rc2 kernel with printk 
> timestamps turned on ... and it booted just fine on my tiger4.  The 
> default path for non-boot cpus is from head.S to start_secondary(), 
> and that calls cpu_init() pretty quickly.  There shouldn't normally[2] 
> be any printk() calls on the non-boot cpu before it is safe to do so.

ok. I've queued up the patch again in sched.git, as a .25 fix. Can i add 
your Tested-by and Acked-by tags?

	Ingo
