Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYEGLAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYEGLAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYEGLAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:00:21 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:54409 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbYEGLAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:00:18 -0400
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: Andi Kleen <andi@firstfloor.org>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang>
	<1210131712.3453.43.camel@ymzhang>
Date: Wed, 07 May 2008 13:00:14 +0200
In-Reply-To: <1210131712.3453.43.camel@ymzhang> (Yanmin Zhang's message of "Wed, 07 May 2008 11:41:52 +0800")
Message-ID: <87lk2mbcqp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2008 10:53:17.0815 (UTC) FILETIME=[8EA4E870:01C8B030]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:
> 3) Caller of lcok_kernel are sys_fcntl/vfs_ioctl/tty_release/chrdev_open.

I have an older patchkit that introduced unlocked_fnctl for some cases. It was 
briefly in mm but then dropped. Sounds like it is worth resurrecting?

tty_* is being taken care of by Alan.

chrdev_open is more work.

-Andi (who BTW never quite understood why BKL is a semaphore now and not
a spinlock?)
