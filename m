Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYDTVfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYDTVfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYDTVfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:35:42 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:34364 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYDTVfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:35:42 -0400
To: "Dan Upton" <upton.dan.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: migration thread and active_load_balance
From: Andi Kleen <andi@firstfloor.org>
References: <ba7d8f720804201121h6c024dcrabd301c8b4be7a4@mail.gmail.com>
Date: Sun, 20 Apr 2008 23:35:19 +0200
In-Reply-To: <ba7d8f720804201121h6c024dcrabd301c8b4be7a4@mail.gmail.com> (Dan Upton's message of "Sun, 20 Apr 2008 14:21:39 -0400")
Message-ID: <87tzhw8b1k.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Apr 2008 21:28:31.0283 (UTC) FILETIME=[7B04D830:01C8A32D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Dan Upton" <upton.dan.linux@gmail.com> writes:

[not a scheduler expert; just some general comments]

> I'm using thread-local variables and really all I'm doing
> right now is assignments to them.  Unless, of course the struct rq
> (from rq = cpu_rq(cpu);) could be being manipulated elsewhere,

Other CPUs can access it yes subject to the lock. You can test that
theory by running with only one CPU.

> leading
> to some sort of race condition...
>
> Anyway, like I said, I've spent several days trying to understand this
> error by putting in printk()s galore and doing traces through the

That might be obvious, but are you aware that printks inside
the scheduler can lead to deadlocks? printk when the buffer
is full calls wake_up and that calls the scheduler. So for
debugging the scheduler you need some other way to get
the information out.

-Andi
