Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYH0GmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYH0GmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYH0GmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:42:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbYH0GmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:42:04 -0400
Date: Wed, 27 Aug 2008 08:41:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhu Yi <yi.zhu@intel.com>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: fix invalid list_del_rcu in zap_class
Message-ID: <20080827064139.GD6255@elte.hu>
References: <20080827063300.GA18265@mail.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827063300.GA18265@mail.intel.com>
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


* Zhu Yi <yi.zhu@intel.com> wrote:

> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008
> IP: [<ffffffff810531e1>] zap_class+0x24/0x82

> The root cause for this oops is in add_lock_to_list() when 
> save_trace() fails due to MAX_STACK_TRACE_ENTRIES is reached, 
> entry->class is assigned but entry is never added into any lock list. 
> This makes the list_del_rcu() in zap_class() oops later when the 
> module is unloaded. This patch fixes the problem by assigning 
> entry->class after save_trace() returns success.

good spotting! Applied to tip/core/urgent, thanks.

	Ingo
