Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbZKKVMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbZKKVMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759055AbZKKVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:12:36 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:48980 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbZKKVMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:12:35 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd)
Date: Wed, 11 Nov 2009 22:15:08 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org
References: <200911091250.31626.rjw@sisk.pl> <200911112100.16561.rjw@sisk.pl> <20091111202433.GA5714@redhat.com>
In-Reply-To: <20091111202433.GA5714@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911112215.08126.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 11. November 2009 21:24:33 schrieb Oleg Nesterov:
> > So, it looks like the bug is in btusb_destruct(), which should call
> > cancel_work_sync() on data->waker before freeing 'data'.  I guess it
> > should do the same for data->work.
> 
> Or. btusb_suspend() and btusb_close() do cancel_work_sync(data->work),
> perhaps they should cancel data->waker as well, I dunno.
> 
> I added Oliver to cc.

btusb_close() must do it. btusb_suspend() must not do it.

	Regards
		Oliver
