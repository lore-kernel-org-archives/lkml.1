Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbZKKVRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbZKKVRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbZKKVRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:17:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37618 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868AbZKKVRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:17:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd)
Date: Wed, 11 Nov 2009 22:18:50 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Oliver Neukum <oliver@neukum.org>,
       linux-bluetooth@vger.kernel.org
References: <200911091250.31626.rjw@sisk.pl> <1257970719.21467.4.camel@violet> <alpine.LFD.2.01.0911111222400.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911111222400.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911112218.50616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 November 2009, Linus Torvalds wrote:
> 
> On Wed, 11 Nov 2009, Marcel Holtmann wrote:
> > 
> > As it seems the btusb_close() only cancels the work workqueue and not
> > the waker workqueue. Could that be the problem.
> 
> It's the waker workqueue that Rafael apparently sees with the debug patch 
> from Oleg, so yeah, that sounds possible.
> 
> Rafael, since apparently htusb_close() _is_ called, does the following 
> simpler patch fix it for you? I bet your patch does it too.

Yes and yes.

And in fact this is a post-2.6.31 regression introduced by commit
7bee549e197c9c0e92b89857a409675c1d5e9dff (Bluetooth: Add USB autosuspend
support to btusb driver).

Thanks,
Rafael
