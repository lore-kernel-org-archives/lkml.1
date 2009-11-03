Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZKCXSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZKCXSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbZKCXSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:18:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbZKCXSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:18:23 -0500
Date: Tue, 3 Nov 2009 15:18:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.32-rc4ish: task umount blocked for more than 120 seconds
 after USB drive removal
Message-Id: <20091103151812.2acc5259.akpm@linux-foundation.org>
In-Reply-To: <4ADE9B79.9090906@gmail.com>
References: <4ADE9B79.9090906@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 23:26:17 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> Running a post-2.6.32-rc4 git kernel, and just unmounted a USB drive 
> after writing a bunch of data to it, then pulled the plug after I 
> thought it had finished unmounting, but apparently it hadn't.. Ran into 
> a hung task warning that repeats every 120 seconds, the umount command 
> for the drive is stuck in D state.
> 
> The full SysRq-T output is shown at the bottom.. any ideas what it's 
> waiting for?

At a guess I'd say the new per-bdi writeback stuff blew up.  Is this
still happening in current mainline?

> Oct 20 21:42:42 newcastle kernel: usb 1-1.6: USB disconnect, address 5
> Oct 20 21:42:42 newcastle gnome-keyring-daemon[2598]: removing removable 
> location: volume_uuid_01E0_9221
> Oct 20 21:45:26 newcastle kernel: INFO: task umount:5380 blocked for 
> more than 120 seconds.
> Oct 20 21:45:26 newcastle kernel: "echo 0 > 
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 20 21:45:26 newcastle kernel: umount        D 0000000000000002     0 
>   5380   2853 0x00000080
> Oct 20 21:45:26 newcastle kernel: ffff880118651bc8 0000000000000086 
> ffff880118651b68 00000000d54e0b08
> Oct 20 21:45:26 newcastle kernel: 00000000000004f1 ffff88013bbd9798 
> ffff8800282558b0 ffff880118651fd8
> Oct 20 21:45:26 newcastle kernel: ffff880118651fd8 ffff8800504cb280 
> 000000000000fb38 0000000000015840
> Oct 20 21:45:26 newcastle kernel: Call Trace:
> Oct 20 21:45:26 newcastle kernel: [<ffffffff8117d534>] ? 
> bdi_sched_wait+0x0/0x39

It's remarkable how much harder these traces are to read post-wordwrapping.
