Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYBDO5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYBDO5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYBDO5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:57:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48902 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYBDO5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:57:46 -0500
Date: Mon, 4 Feb 2008 14:57:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/5] typesafe: TIMER_INITIALIZER and setup_timer
Message-ID: <20080204145736.GX27894@ZenIV.linux.org.uk>
References: <200802042311.18762.rusty@rustcorp.com.au> <200802042317.29130.rusty@rustcorp.com.au> <200802042318.33503.rusty@rustcorp.com.au> <200802042319.44929.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802042319.44929.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 11:19:44PM +1100, Rusty Russell wrote:
> This patch lets timer callback functions have their natural type
> (ie. exactly match the data pointer type); it allows the old "unsigned
> long data" type as well.
> 
> Downside: if you use the old "unsigned long" callback type, you won't
> get a warning if your data is not an unsigned long, due to the cast.

No.  There's much saner way to do that and it does not involve any gccisms
at all.  I'd posted such patches quite a while ago; normal C constructs
are quite sufficient, TYVM.

We don't _need_ that 'allow the old "unsigned long data"' junk.  There's
not enough users of setup_timer() to excuse it; other instances can and
should be converted to setup_timer() one by one, getting their types switched
to sanity as we go.

Let's not mix type safety with that ugliness, please.
