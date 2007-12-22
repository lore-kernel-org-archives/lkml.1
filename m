Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbXLVWhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbXLVWhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 17:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXLVWgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 17:36:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53356 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbXLVWgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 17:36:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Mysterious lockdep warning from the SCSI workqueue code
Date: Sat, 22 Dec 2007 23:56:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
References: <1198344452.3478.9.camel@localhost.localdomain>
In-Reply-To: <1198344452.3478.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712222356.27311.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of December 2007, James Bottomley wrote:
> I've no idea why this is occurring:
> 
> WARNING: at kernel/lockdep.c:700 look_up_lock_class()
> Pid: 2068, comm: scsi_wq_3 Not tainted 2.6.24-rc6 #38
>  [<c010535a>] show_trace_log_lvl+0x1a/0x30
>  [<c0105ce2>] show_trace+0x12/0x20
>  [<c010601c>] dump_stack+0x6c/0x80
>  [<c014696d>] __lock_acquire+0x46d/0x10b0
>  [<c0147628>] lock_acquire+0x78/0xa0
>  [<c0136d18>] run_workqueue+0x128/0x1d0
>  [<c013795c>] worker_thread+0x8c/0xf0
>  [<c013ab32>] kthread+0x42/0x70
>  [<c0104f47>] kernel_thread_helper+0x7/0x10
>  =======================
> 
> it looks to be happening on the initial workqueue.c:run_workqueue()
> 
> 	spin_lock_irq(&cwq->lock);
> 
> It's caused by lockdep.c:look_up_lock_class()
> 
> 	WARN_ON_ONCE(class->name != lock->name);
> 
> but I'm not entirely sure what this actually means, not fully
> understanding lockdep classes and how we acquire them in scsi.

I guess Ingo and/or Peter should have a look at this.

Thanks,
Rafael
