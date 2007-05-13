Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbXEMWgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbXEMWgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 18:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEMWgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 18:36:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537AbXEMWga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 18:36:30 -0400
Date: Sun, 13 May 2007 15:35:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
Message-Id: <20070513153555.7f7dc350.akpm@linux-foundation.org>
In-Reply-To: <20070513200739.GA4137@elte.hu>
References: <20070512030754.90488f79.akpm@linux-foundation.org>
	<1178970253.22481.143.camel@localhost.localdomain>
	<20070512095145.0cf58a57.akpm@linux-foundation.org>
	<1178989302.22481.185.camel@localhost.localdomain>
	<20070512102350.04126320.akpm@linux-foundation.org>
	<1178999770.22481.211.camel@localhost.localdomain>
	<20070512181140.50140334.akpm@linux-foundation.org>
	<1179043652.22481.243.camel@localhost.localdomain>
	<1179074887.22481.271.camel@localhost.localdomain>
	<20070513120937.024a4368.akpm@linux-foundation.org>
	<20070513200739.GA4137@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 22:07:39 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Yeah, I expect quite a few people will start seeing that.  iirc it was 
> > triggered by a couple of changes: a local_irq_save/local_irq_restore 
> > in sched_clock() and a change Jeremy made to the softlockup detector.
> 
> hm, i specifically asked to not do local_irq_save/restore in 
> sched_clock(). It's the _scheduler_ clock and it very absolutely 
> positively needs no flags save/restore.
> 

It got taken out again.

It doesn't matter though: a local_irq_save/restore in some callee shouldn't
cause the locking API tests to break.  And they're apparently now breaking
without that local_irq_save/restore in there anyway.

