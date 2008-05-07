Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbYEGEAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbYEGEAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 00:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYEGD7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:59:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263AbYEGD7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:59:49 -0400
Date: Tue, 6 May 2008 20:59:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-Id: <20080506205930.91ec78b6.akpm@linux-foundation.org>
In-Reply-To: <1210131712.3453.43.camel@ymzhang>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu>
	<1210126286.3453.37.camel@ymzhang>
	<1210131712.3453.43.camel@ymzhang>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 11:41:52 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> As system idle is more than 50%, so the schedule/schedule_timeout caller is important
> information.
> 1) lock_kernel causes most schedule/schedule_timeout;
> 2) When lock_kernel calls down, then __down, __down calls ___schedule_timeout for
> lots of times in a loop;

Really?  Are you sure?  That would imply that we keep on waking up tasks
which then fail to acquire the lock.  But the code pretty plainly doesn't
do that.

Odd.

> 3) Caller of lcok_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.

Still :(
