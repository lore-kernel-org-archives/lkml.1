Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXDXVPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXDXVPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030682AbXDXVPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:15:30 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030241AbXDXVP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:15:28 -0400
Date: Tue, 24 Apr 2007 14:14:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Walker <dwalker@mvista.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Rick Lindsley <ricklind@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, virtualization@lists.osdl.org,
       Chris Lalancette <clalance@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/4] Ignore stolen time in the softlockup watchdog
Message-Id: <20070424141418.887d1d98.akpm@linux-foundation.org>
In-Reply-To: <20070424205918.GA25383@elte.hu>
References: <20070327214919.800272641@goop.org>
	<20070327215827.871954359@goop.org>
	<20070423234910.50149faf.akpm@linux-foundation.org>
	<462E43A7.1050001@goop.org>
	<20070424105738.e0ce36a9.akpm@linux-foundation.org>
	<462E4969.6070802@goop.org>
	<20070424113222.ed2e1314.akpm@linux-foundation.org>
	<462E61F1.7060403@goop.org>
	<462E6778.7070305@goop.org>
	<1177447948.12796.66.camel@imap.mvista.com>
	<20070424205918.GA25383@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 22:59:18 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Tue, 2007-04-24 at 13:24 -0700, Jeremy Fitzhardinge wrote:
> > 
> > > And sched_clock's use of local_irq_save/restore appears to be absolutely
> > > correct, so I think it must be triggering a bug in either the self-tests
> > > or lockdep itself.
> > 
> > Why does sched_clock need to disable interrupts?
> 
> i concur. To me it appears not "absolutely correct" that someone 
> apparently added local_irq_save/restore to sched_clock(), but "absolute 
> madness". sched_clock() is _very_ performance-sensitive for the 
> scheduler, do not mess with it.

Why does a local_irq_save/restore make the selftests fail??
