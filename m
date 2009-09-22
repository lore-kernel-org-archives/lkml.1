Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZIVOr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZIVOr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbZIVOrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:47:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756497AbZIVOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:47:25 -0400
Date: Tue, 22 Sep 2009 07:46:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, davem@davemloft.net, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/printk] ratelimit: Fix/allow use in atomic contexts
In-Reply-To: <tip-edaac8e3167501cda336231d00611bf59c164346@git.kernel.org>
Message-ID: <alpine.LFD.2.01.0909220745420.4950@localhost.localdomain>
References: <new-submission> <tip-edaac8e3167501cda336231d00611bf59c164346@git.kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 22 Sep 2009, tip-bot for Ingo Molnar wrote:
> 
> ratelimit: Fix/allow use in atomic contexts
> 
> I'd like to use printk_ratelimit() in NMI context, but it's not
> robust right now due to spinlock usage in lib/ratelimit.c. If an
> NMI is unlucky enough to hit just that spot we might lock up trying
> to take the spinlock again.
> 
> Fix that by using a trylock variant. If we contend on that lock we
> can genuinely skip the message because the state is just being
> accessed by another CPU (or by this CPU).

Ack to both this and the patch leading up to it. Looks sane and simple.

		Linus
