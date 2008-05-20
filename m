Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbYETCSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbYETCSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754968AbYETCR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:17:59 -0400
Received: from [198.99.130.12] ([198.99.130.12]:35350 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYETCR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:17:58 -0400
Date: Mon, 19 May 2008 22:10:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2
Message-ID: <20080520021048.GA24019@c2.user-mode-linux.org>
References: <aday7665469.fsf@cisco.com> <26562.1211237784@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26562.1211237784@vena.lwn.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 04:56:24PM -0600, Jonathan Corbet wrote:
> ioctl() will not be called on a given file descriptor before open() is
> done, no.  If there are other file descriptors open, though, somebody
> can be calling ioctl() on them while the open() for the new one is
> executing.

There's the case where one thread is calling ioctl on the new
descriptor before open (in other thread) has returned (it's malicious
and trying to oops you, it's accidentally trying to operate on a
closed descriptor, etc).  It might hit the window between the
descripor being installed and open returning.

	  		      Jeff

-- 
Work email - jdike at linux dot intel dot com
