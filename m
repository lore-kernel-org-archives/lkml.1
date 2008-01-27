Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYA0GE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYA0GE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbYA0GES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:04:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757850AbYA0GEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:04:16 -0500
Date: Sat, 26 Jan 2008 22:01:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, dwalker@mvista.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       torvalds@linux-foundation.org, hch@infradead.org,
       mathieu.desnoyers@polymtl.ca, ghaskins@novell.com,
       acme@ghostprotocols.net, tglx@linutronix.de, sam@ravnborg.org,
       fche@redhat.com, jan.kiszka@siemens.com, johnstul@us.ibm.com,
       arjan@infradead.org, srostedt@redhat.com
Subject: Re: [PATCH] defer printks in irqs
Message-Id: <20080126220151.784893b1.akpm@linux-foundation.org>
In-Reply-To: <47991DD7.9070009@am.sony.com>
References: <20080123160236.969334052@goodmis.org>
	<20080123160441.236562634@goodmis.org>
	<1201107978.13596.16.camel@imap.mvista.com>
	<Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>
	<1201110185.13596.22.camel@imap.mvista.com>
	<Pine.LNX.4.58.0801231315500.6127@gandalf.stny.rr.com>
	<47991454.50603@am.sony.com>
	<1201214935.6341.105.camel@lappy>
	<47991DD7.9070009@am.sony.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2008 15:23:03 -0800 Tim Bird <tim.bird@am.sony.com> wrote:
> Peter Zijlstra wrote:
> > I suspect these features reduce the chance a crash messages makes it out
> > onto the console, but fail to spot any of the copious text mention this
> > critical issue.
> 
> Anything not in interrupts would not be deferred.
> The following code is meant to avoid deferring in oops as well.
> I'm not sure if that covers all crash cases or not.
> If you know of other cases, and ways to detect them, please advise.
> 

Yes, using oops_in_progress seems an appropriate fix for that.

I assume that another downside is that printk-from-interrupt will now get
jumbled up with an interrupted pritk-from-non-interrupt.

Please use checkpatch.
