Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbZKKVjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbZKKVjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbZKKVjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:39:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759255AbZKKVjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:39:08 -0500
Date: Wed, 11 Nov 2009 13:38:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oliver Neukum <oliver@neukum.org>
cc: Marcel Holtmann <marcel@holtmann.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-bluetooth@vger.kernel.org
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
 resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related
 to preempt_count leakage in keventd)
In-Reply-To: <200911112213.30673.oliver@neukum.org>
Message-ID: <alpine.LFD.2.01.0911111335410.31845@localhost.localdomain>
References: <200911091250.31626.rjw@sisk.pl> <alpine.LFD.2.01.0911111142340.31845@localhost.localdomain> <1257970719.21467.4.camel@violet> <200911112213.30673.oliver@neukum.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Nov 2009, Oliver Neukum wrote:
> 
> Yes, btusb_close() needs to cancel the waker workqueue, too.
> In addition, in order to avoid a memory leak it must call
> usb_scuttle_anchored_urbs(&data->deferred)
> to make sure any deferred data is destroyed.

Ok. I committed the one-liner patch to fix the oops (confirmed by Rafael), 
but I'm leaving the memory leak for you as I'm not going to commit some 
untested patch at this stage.

Thanks to everybody involved, I was personally very nervous that this was 
something much more fundamental (we've had some scary bugs during the 
32-rc series), and am relieved that it was "just" a silly driver bug.

			Linus
