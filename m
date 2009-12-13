Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZLMSzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZLMSzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 13:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZLMSy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 13:54:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46879 "HELO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753047AbZLMSy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 13:54:58 -0500
Subject: Re: [patch 0/9] Fix various __task_cred related invalid RCU
 assumptions
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091210053457.GB6720@linux.vnet.ibm.com>
References: <20091210001308.247025548@linutronix.de>
	 <20091210022825.GG6938@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.0912091914540.3560@localhost.localdomain>
	 <1260422031.4165.1.camel@twins>  <20091210053457.GB6720@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 13 Dec 2009 19:56:17 +0100
Message-ID: <1260730577.4165.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 21:34 -0800, Paul E. McKenney wrote:

> Ah -- I have a related lockdep question.  Is there a primitive that says
> whether or not the current task holds at least one lock of any type?
> If so, I would like to make rcu_dereference() do at least a little crude
> checking for this problem.

Hmm, no, but that's not hard to do, however I actually implemented
something like that for RCU a long while ago and that gives a metric TON
of false positives due to things like the radix tree which are RCU-safe
but are not required to be used with RCU.


