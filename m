Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYI2RQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYI2RQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYI2RQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:16:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40940 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYI2RQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:16:39 -0400
To: Avi Kivity <avi@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ioctl: generic ioctl dispatcher
From: Andi Kleen <andi@firstfloor.org>
References: <1222530242-1272-1-git-send-email-avi@redhat.com>
	<1222530242-1272-2-git-send-email-avi@redhat.com>
Date: Mon, 29 Sep 2008 19:16:35 +0200
In-Reply-To: <1222530242-1272-2-git-send-email-avi@redhat.com> (Avi Kivity's message of "Sat, 27 Sep 2008 18:44:00 +0300")
Message-ID: <87od26q3d8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> +/**
> + * dispatch_ioctl - dispatch to an ioctl handler based on ioctl number
> + * @inode:	inode to invoke ioctl method on
> + * @filp:	open file to invoke ioctl method on
> + * @cmd:	ioctl command to execute
> + * @arg:	command-specific argument for ioctl
> + * @handlers:	list of potential handlers for @cmd; null terminated;
> + *              place frequently used cmds first
> + * @fallback:   optional function to call if @cmd not found in @handlers
> + *
> + * Locates and calls ioctl handler in @handlers; if none exist, calls
> + * @fallback; if that does not exist, return -ENOTTY.
> + */
> +long dispatch_ioctl(struct inode *inode, struct file *filp,
> +		    unsigned cmd, unsigned long arg,
> +		    const struct ioctl_handler *handlers,
> +		    long (*fallback)(const struct ioctl_arg *arg))

The basic idea is good, but i don't like the proliferation of callbacks,
which tends to make complicated code and is ugly for simple code
(which a lot of ioctls are)

How about you make it return an number that can index a switch() instead?
Then everything could be still kept in the same function.

-Andi
