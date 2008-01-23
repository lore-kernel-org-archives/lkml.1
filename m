Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYAWRoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYAWRoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYAWRnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:43:49 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:50372 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYAWRns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:43:48 -0500
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
	disabled
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>
References: <20080123160236.969334052@goodmis.org>
	 <20080123160441.236562634@goodmis.org>
	 <1201107978.13596.16.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 09:43:05 -0800
Message-Id: <1201110185.13596.22.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 	if (wake_klogd && !runqueue_is_locked())
> 		wake_up_klogd();
> 
> This probably is the cleanest solution since it simply prevents the
> deadlock from occurring.

Do you really need to call it with the runqueue lock held .. There are
other issue with the calls at that level.. For instance in -rt these
call can actually hang the system in the console laying from inside
printk (something I reported more than 6 months ago) .. It would be
better to move them around the scheduler rather than inside it..

Daniel

