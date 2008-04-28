Return-Path: <linux-kernel-owner+w=401wt.eu-S1765092AbYD1CNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765092AbYD1CNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 22:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYD1CNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 22:13:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40837 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYD1CNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 22:13:10 -0400
Date: Mon, 28 Apr 2008 03:13:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH 2/2] loop : Don't hold the lo_ctl_mutex while fput in
	loop_clr_fd
Message-ID: <20080428021309.GZ5882@ZenIV.linux.org.uk>
References: <20080428021022.GB2698@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428021022.GB2698@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 10:10:22AM +0800, Dave Young wrote:
> [Fixing bug 10504]
> 
> If the bakingfile is a block device file, losetuo -d will trigger lockdep
> warning of "circular locking dependency".
> 
> open/release lock order : bdev->bd_mutex ---> lo->lo_ctl_mutex
> loop_clr_fd lock order  : lo->lo_ctl_mutex ---> bdev->bd_mutex (fput)
> 
> Don't hold the lo_ctl_mutex while fput in loop_clr_fd to fix it. It's safe
> because all loop device state will be consistent here.

Explain.
