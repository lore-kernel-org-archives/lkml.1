Return-Path: <linux-kernel-owner+w=401wt.eu-S935587AbYEBPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935587AbYEBPlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765553AbYEBPlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:41:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38694 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759401AbYEBPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:41:01 -0400
Date: Fri, 2 May 2008 16:41:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: remove local variable copy of f_pos to enable
	thread-safe updates
Message-ID: <20080502154100.GF5882@ZenIV.linux.org.uk>
References: <342069.46185.qm@web52010.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <342069.46185.qm@web52010.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 08:33:50AM -0700, Matti Linnanvuori wrote:

> File systems can be written so that implementations of read, lseek etc.
> acquire a lock before using *pos, which precludes races. That was the
> idea behind my patch. So, my patch does not necessarily cause races.
> read instances can be racy in Linux now because there is no lock to
> serialize read etc. system calls.

Oh, yes it does - current tree guarantees that variable passed to ->read()
will not change under it, so any code that relied on that got broken.

And no, modifying every driver's ->read() is not going to be fun - it's
not just filesystems.
