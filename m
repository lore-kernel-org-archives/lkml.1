Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbYJJPkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbYJJPkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759867AbYJJPkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:40:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50484 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758135AbYJJPkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:40:12 -0400
Date: Fri, 10 Oct 2008 17:39:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, jeremy@goop.org, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
Message-ID: <20081010153951.GD28977@elte.hu>
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu> <20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz> <20081009131701.GA21112@elte.hu> <1223559246.11830.23.camel@nimitz> <20081009134415.GA12135@elte.hu> <1223571036.11830.32.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223571036.11830.32.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Thu, 2008-10-09 at 15:44 +0200, Ingo Molnar wrote:
> > there might be races as well, especially with proxy state - and 
> > current->flags updates are not serialized.
> > 
> > So maybe it should be a completely separate flag after all? Stick it 
> > into the end of task_struct perhaps.
> 
> What do you mean by proxy state?  nsproxy?

it's a concept: one task installing some state into another task (which 
state must be restored after a checkpoint event), while that other task 
is running. Such as a pi-futex state for example.

So a task can acquire state not just by its own doing, but via some 
other task too.

	Ingo
