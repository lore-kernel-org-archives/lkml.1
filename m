Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbXFVOrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbXFVOrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbXFVOrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:47:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39221 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbXFVOri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:47:38 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <1182523330.5493.69.camel@localhost.localdomain>
References: <20070622040014.234651401@goodmis.org>
	 <1182522309.2672.11.camel@laptopd505.fenrus.org>
	 <1182523330.5493.69.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 22 Jun 2007 07:43:34 -0700
Message-Id: <1182523414.2672.16.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> This is stated on the assumption that pretty much all performance
> critical tasklets have been removed (although Christoph just mentioned
> megaraid_sas, but after I made this statement).
> 
> We've been running tasklets as threads in the -rt kernel for some time
> now, and that hasn't bothered us.
> 
> The problem with tasklets is that they still don't provide guaranteed
> performance. They can still be pushed off to ksoftirqd on a busy system.
> But having *all* tasklets as they are today, keeps them at a higher
> priority then any process in the system.


don't get me wrong, I'm not against this conversion, just it needs to be
measured in detail... or preferably done step by step so that the
performance guys can undo one piece at a time until they find a guilty
party ;)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

