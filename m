Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYHaKhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYHaKhq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 06:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbYHaKhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 06:37:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:53663 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbYHaKhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 06:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U9eUqj5PXkNYAS/rdhaWjM241kRZnB7DKJCh0Hax09i7P0wynxw7lOGaCIwBLrxBoq
         YTdB0wi/rSxidpNZ9qEZ0vSAWSfe3t7rvs+Ld7/2ogCEV7cjAfZSWz6t6mBAQwh7yapa
         +bZS2xTNp29zaWyS/w0Zh4DbnDtHioN6YSUV0=
Date: Sun, 31 Aug 2008 14:37:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Wagner <daw-news@cs.berkeley.edu>, linux-kernel@vger.kernel.org
Subject: Re: buffer overflow in /proc/sys/sunrpc/transports
Message-ID: <20080831103733.GG7391@lenovo>
References: <20080830184422.GA9598@localhost.localdomain> <20080830190642.GC7611@lenovo> <g9cj5n$tjv$1@taverner.cs.berkeley.edu> <20080831103026.GF7391@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080831103026.GF7391@lenovo>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Aug 31, 2008 at 02:30:26PM +0400]
...
| 
| | 
| | 2. Is it OK to dereference *lenp directly?  Is lenp a pointer into user
| | memory or kernel memory?  If it points to user memory, why is it safe to
| | dereference it directly?  (What about TOCTTOU bugs?)  Should there be
| | some sparse annotations here to ensure the code is not dereferencing
| | user pointers directly?  Later on, proc_do_xprt() also dereferences
| | *lenp and *ppos directly.

on second view: will check for TOCTTOU bug (iirc vfs layer does
latch file descriptor for these kind of operations)

| 
| Not only proc_do_xprt do that so I think it's safe (check for NULL
| on highr level I suspect).
| 
...

		- Cyrill -
