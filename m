Return-Path: <linux-kernel-owner+w=401wt.eu-S1750912AbXA3Szz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbXA3Szz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbXA3Szz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:55:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42664 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXA3Szy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:55:54 -0500
Date: Tue, 30 Jan 2007 10:27:18 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       dipankar@in.ibm.com, Gautham Shenoy <ego@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-Id: <20070130102718.f03f37d8.akpm@osdl.org>
In-Reply-To: <200701301744.48601.rjw@sisk.pl>
References: <20070126112837.059502fc.akpm@osdl.org>
	<20070130073340.GC30160@elte.hu>
	<20070130160244.GB2092@linux.vnet.ibm.com>
	<200701301744.48601.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 17:44:47 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > I need to look at all uses of PF_NOFREEZE -- as I understand the
> > code, processes marked PF_NOFREEZE will continue running, potentially
> > interfering with the hotplug operation.  :-(
> > 
> > I will pass my findings on to this list.
> 
> Well, I did it some time ago, although not very thoroughly.
> 
> AFAICS there are not so many, but one that stands out is the worker threads.
> We needed two of them to actually go to sleep, so now it's possible to create
> a "freezeable workqueue" the worker thread of which will not set PF_NOFREEZE,
> but currently this is only used by XFS.

Or we can create a variant of freeze_processes which ignores PF_NOFREEZE.

As I said eariler, we might need to change the freezer code for this
application.  In fact we should do so: that sys_sync() call in there is
quite inappropriate, as is, I suppose, the two-pass freeze attempt.  As are
the nice printks, come to that.


Pretty simple stuff though.

