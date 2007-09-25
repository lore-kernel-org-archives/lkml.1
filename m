Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbXIYBNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbXIYBNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 21:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXIYBNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 21:13:25 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:56555 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbXIYBNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 21:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LgL3RvsF84F6bE3vF0P5OkUyJaww9NQy/GENk5DDi+xMUCCwI6YeIGN7rPf+CIE61Ho4mPUF+nTm1dcr0ugclEiyAPzn1krx2JFOc2s4S+soL+S3D7JlEXC9v6cNhhmH9++p+H/UNVuM3GibM+18oXK03wGKVNtqxvJEeVWN/QM=
Date: Tue, 25 Sep 2007 09:13:16 +0800
From: lepton <ytht.net@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: lepton <ytht.net@gmail.com>, lkm <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.22.6 user-mode linux: use address instead of value as argument in os_free_irq_by_cb
Message-ID: <20070925011316.GA2453@router.lepton.home>
References: <20070922043955.GA4550@router.lepton.home> <20070924170220.GE23078@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924170220.GE23078@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I added dump_stack and some printk in host kernel. The following is what 
I got when sys_reboot in host kernel is called, the first line is 
printing the process state and ptrace state and pid of the calling
process. the following is the call path.

Sep 22 14:25:49 pc kernel: linux         Rptrace: 00000000 pid:3698
Sep 22 14:25:49 pc kernel:  [<c01234a7>] kernel_halt+0x8/0x24
Sep 22 14:25:49 pc kernel:  [<c01239b2>] sys_reboot+0x14c/0x1c7
Sep 22 14:25:49 pc kernel:  [<c0120712>] recalc_sigpending+0xb/0x1d
Sep 22 14:25:49 pc kernel:  [<c0121ed2>] dequeue_signal+0x9d/0x11b
Sep 22 14:25:49 pc kernel:  [<c012222b>]
get_signal_to_deliver+0xe1/0x389
Sep 22 14:25:49 pc kernel:  [<c0101bd5>] do_notify_resume+0x84/0x5f1
Sep 22 14:25:49 pc kernel:  [<c012212c>] ptrace_notify+0x6f/0x8d
Sep 22 14:25:49 pc kernel:  [<c010249e>] syscall_call+0x7/0xb
Sep 22 14:25:49 pc kernel:  =======================
Sep 22 14:25:50 pc kernel: sd 1:0:0:0: [sda] Synchronizing SCSI cache
Sep 22 14:25:50 pc kernel: sd 1:0:0:0: [sda] Stopping disk
Sep 22 14:25:51 pc kernel: System halted.

On Mon, Sep 24, 2007 at 01:02:20PM -0400, Jeff Dike wrote:
> I would say that you shouldn't be running UMLs as root.  However, a
> sys_reboot shouldn't escape being ptraced either.  This is a bug, but
> I don't see any connection between it and ptrace missing a final
> system call.
> 
> 				Jeff
> 
> -- 
> Work email - jdike at linux dot intel dot com
