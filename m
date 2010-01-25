Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788Ab0AYOsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab0AYOsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374Ab0AYOsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:48:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:44624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0AYOsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:48:21 -0500
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for 
 analyzing lock statistics
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <a6b9f31a1001250615y6e4501b3k17074bcc4ce26c7c@mail.gmail.com>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100122164248.GA2651@redhat.com>
	 <a6b9f31a1001250615y6e4501b3k17074bcc4ce26c7c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 15:48:03 +0100
Message-ID: <1264430883.4283.1907.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 23:15 +0900, Hitoshi Mitake wrote:
> 
> As Peter told, this patch series depends on lockdep.
> But, checking dependency and tracing lock events are
> essentially different things. So I think dividing these is possible.

Still you need quite a lot of instrumentation at the actual lock sites,
not something you'd want to have on your production machine.

> But, perf depends on debugfs.
> I don't know about production box well,
> does your production box turns on debugfs?
> It seems that debugfs is not a thing for production box...

debugfs isn't a problem to have.

> And I'm interesting in in-kernel histogram of locks.
> Is there requirement of it?
> I have some ideas (not done yet, completely).

No real concrete ideas yet.. One possibility is to add a range,
bucket_size tuple to perf_event_attr and store the histrogram in the
mmap() area instead of samples.

One difficulty is how to specify what to make that histogram over.

Anyway, its all open still..

