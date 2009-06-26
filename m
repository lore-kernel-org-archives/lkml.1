Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbZFZTu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbZFZTu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbZFZTuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:50:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35219 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754832AbZFZTuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:50:51 -0400
Date: Fri, 26 Jun 2009 15:50:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Gleixner <tglx@linutronix.de>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Deleting timers
Message-ID: <Pine.LNX.4.44L0.0906261535140.4155-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas:

The major difference -- in fact, almost the only difference -- between
del_timer() and try_to_del_timer_sync() is that try_to_del_timer_sync
returns a special code (-1) if the timer couldn't be deleted because it
is currently running, whereas del_timer doesn't check this.

Furthermore, the "_sync" in the name suggests that 
try_to_del_timer_sync will wait until a running timer has finished, 
which it clearly does not do.

Despite these facts, the kerneldoc for try_to_del_timer_sync states 
that it must not be called in interrupt context.  Why not?  Isn't that
advice simply wrong?

With this in mind, would there be any objection if I renamed it to 
try_to_del_timer(), removed the comment forbidding it to be used in 
interrupt context, and made it available even on non-SMP builds?

Alan Stern

P.S.: The only other difference is that del_timer calls
timer_stats_timer_clear_start_info.  Why doesn't try_to_del_timer_sync
do the same thing?

