Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYHDPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYHDPru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbYHDPri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:47:38 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:60340 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756090AbYHDPrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:47:37 -0400
X-Nifty-SrcIP: [210.170.193.38]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=v5GJhaV454bqksSjQ717oXVwWGcCOfIHee/mwq32OwAOMyWQHuFXvF2n58RUzI0Y1eqrfY/PF7RiIlofCBjB4g==  ;
Date: Tue, 05 Aug 2008 00:09:43 +0900 (JST)
Message-Id: <20080805.000943.208968239.takada@mbf.nifty.com>
To: linux-kernel@vger.kernel.org
Subject: How does RCU work?
From: TAKADA Yoshihito <takada@mbf.nifty.com>
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I cannot understand mechanism. Somebody tell me it please.

In x86 kernel, CONFIG_PREEMPT_RCU=n (CONFIG_CLASSIC_RCU=y). rcu_read_lock() makes
just preempt_disable().
call_cru()/synchronize_rcu() running as a soft-IRQ.
It's current CPU does not refer to protected data that when call_rcu() run. 
Because soft-IRQ handler ran, it means current CPU is preempive. That is the CPU
called rcu_read_unlock().

Well, current CPU is unlocked, but How does kernel know it other CPUs unlocked?

call_ruc() calls force_quiescent_state() to reschedule other CPUs. 
force_quiescent_state() calls smp_send_reschedule() to sends request to reshecule.
It's just require to reschedule via inter Processor Interrupt. But call_rcu() does
not wait for target CPUs handle IPI. Or, Do CPUs have it handled IPI request when
return from smp_send_reschedule()?

