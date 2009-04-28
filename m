Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbZD1Vlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbZD1Vlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZD1VlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:41:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46880 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbZD1VlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:41:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090428194537.GN6730@linux.vnet.ibm.com>
References: <20090428194537.GN6730@linux.vnet.ibm.com> <20090329203118.GA14005@linux.vnet.ibm.com> <20090203183426.GA14409@linux.vnet.ibm.com> <13990.1240928654@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, niv@us.ibm.com, dvhltc@us.ibm.com,
       lethal@linux-sh.org, kernel@wantstofly.org, matthew@wil.cx
Subject: Re: [PATCH] v3 RCU: the bloatwatch edition
Date: Tue, 28 Apr 2009 22:39:59 +0100
Message-ID: <1454.1240954799@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Your thought is that some of the functions could be moved to tinyrcu.h?
> Indeed, some of them would be smaller if inlined than even the call
> sequence.  For example, rcu_needs_cpu() should remove code from the
> dynticks implementation given that it always returns zero.

tinyrcu.h is probably not a bad idea.  Some of the functions are trivial, and
the code to do a function call is bigger than the body of the function itself.

rcu_exit_nohz(), rcu_nmi_enter/exit(), rcu_batches_completed[_bh](), for
example.  Even call_rcu() and call_rcu_bh() might perhaps benefit from
inlining.

David
