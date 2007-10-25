Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbXJYELw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbXJYELw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXJYELo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:11:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192AbXJYELn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:11:43 -0400
Date: Wed, 24 Oct 2007 21:11:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 4/5] Add lock_page_killable
Message-Id: <20071024211140.329fdd90.akpm@linux-foundation.org>
In-Reply-To: <11932286982653-git-send-email-matthew@wil.cx>
References: <11932286982175-git-send-email-matthew@wil.cx>
	<11932286982653-git-send-email-matthew@wil.cx>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 08:24:57 -0400 Matthew Wilcox <matthew@wil.cx> wrote:

> and associated infrastructure such as sync_page_killable and
> fatal_signal_pending.  Use lock_page_killable in do_generic_mapping_read()
> to allow us to kill `cat' of a file on an NFS-mounted filesystem.

whoa, big change.

What exactly are the semantics here?  If the process has actually been
killed (ie: we know that userspace won't be running again) then we break
out of a lock_page() and allow the process to exit?  ie: it's basically
invisible to userspace?

If so, it sounds OK.  I guess.  We're still screwed if the process is doing
a synchronous write and lots of other scenarios.

How well has this been tested?

Have the NFS guys had a think about it?

Why does it return -EIO from read() and not -EINTR?
