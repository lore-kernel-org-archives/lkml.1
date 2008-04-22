Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYDVEVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYDVEVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 00:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYDVEVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 00:21:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45179 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYDVEVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 00:21:08 -0400
Date: Mon, 21 Apr 2008 21:20:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] use canary at end of stack to indicate overruns at oops
 time
Message-ID: <20080421212058.0c51db01@laptopd505.fenrus.org>
In-Reply-To: <480D5F27.1030101@redhat.com>
References: <480D5F27.1030101@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 22:44:39 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> Use a canary at the end of the stack to clearly indicate
> at oops time whether the stack has ever overflowed.
> 
> This is a very simple implementation with a couple of
> drawbacks:
> 
> 1) a thread may legitimately use exactly up to the last 
>    word on the stack
> 
>  -- but the chances of doing this and then oopsing later seem slim
> 
> 2) it's possible that the stack usage isn't dense enough
>    that the canary location could get skipped over
> 
>  -- but the worst that happens is that we don't flag the overrun
> 
> With the code in place, an intentionally-bloated stack oops does:
> 
> BUG: unable to handle kernel paging request at ffff8103f84cc680
> IP: [<ffffffff810253df>] update_curr+0x9a/0xa8
> PGD 8063 PUD 0 
> Thread overran stack or stack corrupted
> Oops: 0000 [1] SMP 
> CPU 0 

I like this but I wonder if it's useful to do this for the irq stacks too;

either way

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

(I'll also add detection of your printk to the kerneloops.org website)
