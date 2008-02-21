Return-Path: <linux-kernel-owner+w=401wt.eu-S1762655AbYBUGEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762655AbYBUGEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYBUGEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:04:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53782 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbYBUGEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:04:44 -0500
Date: Thu, 21 Feb 2008 07:04:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Make yield_task_fair more efficient
Message-ID: <20080221060427.GA9159@elte.hu>
References: <20080221053321.GA26918@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221053321.GA26918@balbir.in.ibm.com>
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


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> __pick_last_entity() walks the entire tree on O(lgn) time to find the 
> rightmost entry. This patch makes the routine more efficient by 
> reducing the cost of the lookup

hm, i'm not sure we want to do this: we'd be slowing down the fastpath 
of all the other common scheduler functions, for the sake of a rarely 
used (and broken ...) API: yield. And note that an rbtree walk is not 
slow at all - if you are yielding frequently it's probably all cached.

	Ingo
