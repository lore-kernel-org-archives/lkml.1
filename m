Return-Path: <linux-kernel-owner+w=401wt.eu-S1764609AbXGaO1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764609AbXGaO1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760357AbXGaO0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:26:49 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:20487 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758189AbXGaO0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:26:47 -0400
Message-Id: <46AF0DF9.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 31 Jul 2007 10:26:36 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 1/2] RT: Preemptible Function-Call-IPI Support
References: <20070730211350.5162.99143.stgit@novell1.haskins.net>
 <20070730211539.5162.87483.stgit@novell1.haskins.net>
 <20070731091903.GA15822@elte.hu> <20070731092119.GA15968@elte.hu>
 <20070731092521.GA16177@elte.hu>
In-Reply-To: <20070731092521.GA16177@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jul 31, 2007 at  5:25 AM, in message <20070731092521.GA16177@elte.hu>,
Ingo Molnar <mingo@elte.hu> wrote: 


> as far as the prioritization of function calls goes, _that_ makes sense, 
> but it should not be a separate API but should be done to our normal 
> workqueue APIs. That not only extends the effects of priorities to all 
> current workqueue using kernel subsystems, but also keeps the API more 
> unified. We really dont want to have too many -rt specific APIs.

I just took a look at the workqueue code .  There are two immediate problems that I see:

1) cpu_workqueue_struct->lock is a spinlock_t and will need to become a raw_spinlock_t

2) The lock is held for the duration of the execution of workqueue items.  We will need to revamp this such that new workqueue items can still be queued even while executing others.

Are these acceptable changes?  If so, I will put together a prototype based around this concept.

Regards,
-Greg




