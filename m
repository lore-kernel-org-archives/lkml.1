Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYIJXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYIJXjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYIJXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:39:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbYIJXjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:39:07 -0400
Date: Wed, 10 Sep 2008 16:39:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Peterson <joe@skyrush.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
Message-Id: <20080910163902.2b7ac22b.akpm@linux-foundation.org>
In-Reply-To: <48C6DFA4.5040406@skyrush.com>
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>
	<48AC3A16.4080209@skyrush.com>
	<48B3F9F7.2050503@skyrush.com>
	<48C54EC2.4060901@skyrush.com>
	<20080908173250.2452c5b8.akpm@linux-foundation.org>
	<20080909115536.1664d57a@lxorguk.ukuu.org.uk>
	<20080909104325.4653190b.akpm@linux-foundation.org>
	<48C6DFA4.5040406@skyrush.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2008 14:42:12 -0600
Joe Peterson <joe@skyrush.com> wrote:

> 1) Fix tab erasure handling
> 2) Improve locking when working with the echo buffer
> 3) Remove the big kernel lock (BKL) from n_tty
> 
> Tab erasure handling is now more robust and able to handle non-zero
> canon column cases more correctly.  This is done by making correct use
> of what is known in the eraser function (read buffer contents) and what
> is known at the time of processing the tab erasure (column state).
> 
> Also, better locking of the echo buffer will now prevent any attempts to
> process partial multi-byte echo operations.  And since the echo buffer
> code now isolates the tty column state code to the process_out* and
> process_echoes functions, we can remove the big kernel lock (BKL)
> and replace it with more modern mutex locks.

Boy.  Has this been carefully tested with lockdep enabled?
