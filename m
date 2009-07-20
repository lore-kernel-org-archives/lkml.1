Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZGTLii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZGTLii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 07:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbZGTLig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 07:38:36 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:10523 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZGTLig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 07:38:36 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:sched/core] sched: Pull up the might_sleep() check into
 cond_resched()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090720081210.GA5309@nowhere>
References: <1247725694-6082-6-git-send-email-fweisbec@gmail.com>
	 <tip-613afbf83298efaead05ebcac23d2285609d7160@git.kernel.org>
	 <4A6413AB.2050807@cn.fujitsu.com>  <20090720081210.GA5309@nowhere>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 13:39:15 +0200
Message-Id: <1248089955.15751.8494.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 04:12 -0400, Frederic Weisbecker wrote:

> Hm, I can read that in fs/dcache.c:512
> 
> /* dentry->d_lock was dropped in prune_one_dentry() */
> cond_resched_lock(&dcache_lock);

dentry->d_lock != dcache_lock

> Isn't it a mususe of cond_resched_lock() ?
> In this case, dcache.c should be fixed.

Both sites look good wrt locking. So there's something else fishy.

