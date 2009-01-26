Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbZAZRm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbZAZRm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZAZRlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:41:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZAZRlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:41:52 -0500
Subject: Re: [RFC][PATCH 2/2] add a counter for writers spinning on a rwlock
From: Peter Zijlstra <peterz@infradead.org>
To: Mandeep Baines <msb@google.com>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1fe6c7900901260936g63ea73a4naf1b90190352d057@mail.gmail.com>
References: <497cd08f.0c11660a.33a7.ffffdf39@mx.google.com>
	 <1232977715.4863.81.camel@laptop>
	 <c62985530901260725s2f36c6d8u1572775d790e7888@mail.gmail.com>
	 <1232984248.4863.106.camel@laptop>
	 <c62985530901260804o4022e0c0t5acba3f7c32c48ac@mail.gmail.com>
	 <1fe6c7900901260936g63ea73a4naf1b90190352d057@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 18:41:41 +0100
Message-Id: <1232991701.4863.222.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 09:36 -0800, Mandeep Baines wrote:

> Unfortunately, this can't be done for hung_task. It writes to the
> task_struct here:

Don't top post!

> static void check_hung_task(struct task_struct *t, unsigned long now,
>                             unsigned long timeout)
> {
>         unsigned long switch_count = t->nvcsw + t->nivcsw;
> 
>         if (t->flags & PF_FROZEN)
>                 return;
> 
>         if (switch_count != t->last_switch_count || !t->last_switch_timestamp) {
>                 t->last_switch_count = switch_count;
>                 t->last_switch_timestamp = now;
>                 return;
>         }
> 
> It is able to get away with using only a read_lock because no one else
> reads or writes to these fields.

How would RCU be different here?

