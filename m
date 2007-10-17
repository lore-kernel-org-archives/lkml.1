Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbXJQT1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbXJQT1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbXJQT1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:27:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58540 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbXJQT1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:27:40 -0400
Date: Wed, 17 Oct 2007 20:27:37 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] file operations: release can race with read/write?
Message-ID: <20071017192737.GJ8181@ftp.linux.org.uk>
References: <adave96ki0x.fsf@cisco.com> <adaodexh9uz.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaodexh9uz.fsf@cisco.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 11:30:44AM -0700, Roland Dreier wrote:
> [Resending, directly to a couple likely suspects this time, in the
> hope of getting a reply... thanks]
> 
> I have a question about the synchronization of file_operations: is it
> intended that the .release method of a file can be called while a
> .read or .write method is still running for that file?

> I've written a quick test case that seems to show this happen in
> practice, and reading the code in fs/open.c and fs/read_write.c I see
> no reason why this race can't happen: sys_read() and sys_write() just
> do fget_light(), which will not increment the file's reference count
> on the fast path, so a racing sys_close() from another thread could do
> the final fput() that ends up calling the file's .release method
> before the read or write has finished.

If you _have_ another thread to call close() from, you won't hit that
fast path.  Case closed.
