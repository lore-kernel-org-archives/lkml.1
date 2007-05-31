Return-Path: <linux-kernel-owner+w=401wt.eu-S1760708AbXEaXsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760708AbXEaXsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbXEaXsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:48:04 -0400
Received: from [198.99.130.12] ([198.99.130.12]:34907 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbXEaXsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:48:01 -0400
Date: Thu, 31 May 2007 19:39:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] Syslets - Fix cachemiss_thread return value
Message-ID: <20070531233946.GA12493@c2.user-mode-linux.org>
References: <20070531181923.GA9904@c2.user-mode-linux.org> <20070531220716.GL5488@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531220716.GL5488@mami.zabbo.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 03:07:16PM -0700, Zach Brown wrote:
> Can you explain what motivated you to send out this patch?
> 
> It used to return 0.  It was changed because, unlike the syslet
> syscalls, sys_io_submit() doesn't have a simple 0 value to indicate
> success.  The current implementation wants to return the number of iocbs
> that were processed, including the one which blocked, from the cachemiss
> thread.  So before calling into an operation it sets task_ret_ret() so
> that the cachemiss thread can return it if it takes over.
> task_ret_reg() is holding a return value that is being returned by the
> cachemiss thread on behalf of a sys_io_submit() which blocked.
> 
> When I made the change I didn't really audit its effect on the other
> paths.  I suppose it's time to do that, and you could help by telling me
> if you saw something bad happen :).

The bad thing was sys_async_exec returning -NOSYS every time a new
cachemiss thread was created.

Without this patch, you'll see sys_async_exec failures with either of
the demos I sent out.  Dunno about the existing ones, but I bet they do
the same.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
