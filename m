Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbXJWVOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbXJWVOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXJWVNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:13:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35837 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbXJWVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:13:38 -0400
Date: Tue, 23 Oct 2007 15:13:37 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: Sparse fix for scsi_request_fn
Message-ID: <20071023211337.GT27248@parisc-linux.org>
References: <20071023014845.GN27248@parisc-linux.org> <alpine.LFD.0.999.0710221908130.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710221908130.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 07:09:56PM -0700, Linus Torvalds wrote:
> Umm. This is why we write things like
> 
> 	static void double_lock_balance(struct rq *this_rq, struct rq *busiest)
> 		__releases(this_rq->lock)
> 		__acquires(busiest->lock)
> 		__acquires(this_rq->lock)
> 	{
> 		...
> 
> ie your "__holds()" is nothing new, and should be written as 
> a pair of __releases(x) and __acquires(x), which is more readable anyway 
> (since it actually says what the function does!)

Thanks, I hadn't realised that sparse would unify the two declarations.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
