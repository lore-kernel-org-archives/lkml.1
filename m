Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZEXT6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZEXT6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZEXT6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:58:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33730 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbZEXT6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:58:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: 2 bugs related to suspend to disk
Date: Sun, 24 May 2009 21:58:14 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
References: <4A199A7A.3010705@gmail.com>
In-Reply-To: <4A199A7A.3010705@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905242158.15093.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 May 2009, Marcin Slusarz wrote:
> 1) echo platform > /sys/power/disk; echo disk > /sys/power/state
> 
> works but prints:
> 
> BUG: sleeping function called from invalid context at include/linux/writeback.h:87
> in_atomic(): 1, irqs_disabled(): 0, pid: 6509, name: sh
> 3 locks held by sh/6509:
>  #0:  (&buffer->mutex){+.+.+.}, at: [<>] sysfs_write_file+0x38/0x119
>  #1:  (pm_mutex){+.+.+.}, at: [<>] hibernate+0x17/0x169
>  #2:  (swap_lock){+.+...}, at: [<>] swap_type_of+0x2e/0xed
> Pid: 6509, comm: sh Not tainted 2.6.30-rc7-mod #124
> Call Trace:
>  ? __debug_show_held_locks
>  ? bdev_test
>  __might_sleep
>  ifind
>  ? bdev_test
>  iget5_locked
>  ? bdev_set
>  bdget
>  swap_type_of
>  swsusp_write
>  ? acpi_sleep_tts_switch
>  hibernate
>  state_store
>  kobj_attr_store
>  sysfs_write_file
>  vfs_write
>  sys_write
>  system_call_fastpath
> 
> 2) "s2disk" (from suspend-0.8) suspends, but doesn't resume (and I need to mkswap && swapon -a later)
> 
> It's not a regression, because I never tried to STD (STR worked).

Both look strange, at least the first one does.

Thanks for the report, I'll do my best to take care of this as soon as I can.

Best,
Rafael
