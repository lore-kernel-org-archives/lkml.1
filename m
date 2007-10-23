Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbXJWCK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbXJWCK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXJWCKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:10:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbXJWCKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:10:10 -0400
Date: Mon, 22 Oct 2007 19:09:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: James Bottomley <James.Bottomley@steeleye.com>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: Sparse fix for scsi_request_fn
In-Reply-To: <20071023014845.GN27248@parisc-linux.org>
Message-ID: <alpine.LFD.0.999.0710221908130.30120@woody.linux-foundation.org>
References: <20071023014845.GN27248@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Oct 2007, Matthew Wilcox wrote:
>
> Introduce new __holds() macro to tell sparse it's OK to drop and then
> reacquire a lock within a function.  Use it in scsi_request_fn.

Umm. This is why we write things like

	static void double_lock_balance(struct rq *this_rq, struct rq *busiest)
		__releases(this_rq->lock)
		__acquires(busiest->lock)
		__acquires(this_rq->lock)
	{
		...

ie your "__holds()" is nothing new, and should be written as 
a pair of __releases(x) and __acquires(x), which is more readable anyway 
(since it actually says what the function does!)

		Linus
