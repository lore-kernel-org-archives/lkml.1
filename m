Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbZKKVmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbZKKVmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbZKKVmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:42:03 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:47134 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759314AbZKKVmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:42:02 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd)
Date: Wed, 11 Nov 2009 22:44:35 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Marcel Holtmann <marcel@holtmann.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-bluetooth@vger.kernel.org
References: <200911091250.31626.rjw@sisk.pl> <200911112213.30673.oliver@neukum.org> <alpine.LFD.2.01.0911111335410.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911111335410.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911112244.35320.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 11. November 2009 22:38:08 schrieb Linus Torvalds:
> On Wed, 11 Nov 2009, Oliver Neukum wrote:
> > Yes, btusb_close() needs to cancel the waker workqueue, too.
> > In addition, in order to avoid a memory leak it must call
> > usb_scuttle_anchored_urbs(&data->deferred)
> > to make sure any deferred data is destroyed.
> 
> Ok. I committed the one-liner patch to fix the oops (confirmed by Rafael),
> but I'm leaving the memory leak for you as I'm not going to commit some
> untested patch at this stage.
> 
> Thanks to everybody involved, I was personally very nervous that this was
> something much more fundamental (we've had some scary bugs during the
> 32-rc series), and am relieved that it was "just" a silly driver bug.

Thanks. A patch is in the works.

	Regards
		Oliver
