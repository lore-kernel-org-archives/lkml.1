Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302Ab0BNDwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 22:52:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60587 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0BNDwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 22:52:10 -0500
Date: Sun, 14 Feb 2010 03:52:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/4] Check O_* flags set with fcntl() on anon_inode
 files.
Message-ID: <20100214035205.GU30031@ZenIV.linux.org.uk>
References: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266107267-5920-1-git-send-email-matthltc@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 04:27:43PM -0800, Matt Helsley wrote:
> anon_inode interfaces often do not support flags that can be set
> by fcntl(). Right now using fcntl() to set these flags falsely
> reports success for things like O_ASYNC yet SIGIO is not delivered.
> 
> I relied on the flags allowed by the syscalls that create
> these files to determine the flags that are allowed to be set by
> fcntl().
> 
> Each patch checks flags for one anonymous inode interface:
> 
> [PATCH 1/4] signalfd
> [PATCH 2/4] timerfd
> [PATCH 3/4] epoll
> [PATCH 4/4] eventfd
> 
> I did not check the perf, kvm-vm, or kvm-vcpu uses of anon_inodes.

Er...  O_ASYNC is silently ignored for regular files as well, so any
userland code that tries to rely on fcntl() rejecting it is and always
had been badly b0rken.
