Return-Path: <linux-kernel-owner+w=401wt.eu-S932316AbXGaUht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbXGaUht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934338AbXGaUgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:36:48 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42815 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbXGaUgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:36:46 -0400
X-Greylist: delayed 1247 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 16:36:46 EDT
Subject: Re: [PATCH 1/2] RT: Preemptible Function-Call-IPI Support
From: Gregory Haskins <ghaskins@novell.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <46AF0DFC.BA47.005A.0@novell.com>
References: <20070730211350.5162.99143.stgit@novell1.haskins.net>
	 <20070730211539.5162.87483.stgit@novell1.haskins.net>
	 <20070731091903.GA15822@elte.hu> <20070731092119.GA15968@elte.hu>
	 <20070731092521.GA16177@elte.hu>  <46AF0DFC.BA47.005A.0@novell.com>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 16:14:14 -0400
Message-Id: <1185912854.9513.64.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 10:26 -0400, Gregory Haskins wrote:
> >>> On Tue, Jul 31, 2007 at  5:25 AM, in message <20070731092521.GA16177@elte.hu>,
> Ingo Molnar <mingo@elte.hu> wrote: 
> 
> 
> > as far as the prioritization of function calls goes, _that_ makes sense, 
> > but it should not be a separate API but should be done to our normal 
> > workqueue APIs. That not only extends the effects of priorities to all 
> > current workqueue using kernel subsystems, but also keeps the API more 
> > unified. We really dont want to have too many -rt specific APIs.
> 
> I just took a look at the workqueue code .  There are two immediate problems that I see:
> 
> 1) cpu_workqueue_struct->lock is a spinlock_t and will need to become a raw_spinlock_t
> 
> 2) The lock is held for the duration of the execution of workqueue items.  We will need to revamp this such that new workqueue items can still be queued even while executing others.
> 

Duh...scratch #2.  I missed the unlock/lock sequence. :P

#1 is still a potential problem, as is the use of completion variables.

-Greg



