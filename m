Return-Path: <linux-kernel-owner+w=401wt.eu-S1764484AbZAULuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764484AbZAULuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbZAULu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:50:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:59546 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbZAULu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:50:27 -0500
Subject: Re: lockdep and debug objects together are broken?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090121114229.GA10606@elte.hu>
References: <20090120085559.GB19505@wotan.suse.de>
	 <19f34abd0901201311t2425056dia6182812f7270297@mail.gmail.com>
	 <20090121071950.GM24891@wotan.suse.de>  <20090121114229.GA10606@elte.hu>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 12:50:02 +0100
Message-Id: <1232538602.4847.158.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 12:42 +0100, Ingo Molnar wrote:

> So by the time you'd rearm, there's a lot of tasks with no proper locking 
> state built up. We might be able to re-arm via stop_machine_run perhaps.

Won't work either, kstopmachine only preempts everybody. We'd require
something stronger.

What we need is a point where there's guaranteed no locks held, for
regular tasks that would be a trip to userspace and back, but for kernel
tasks that's a bit harder -- does the freezer stuff guarantee this?

Supposing we have such a point for all tasks, what you then do is wipe
all lock state and rig a trigger to start tracking lock state once you
passed through the point.



