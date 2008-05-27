Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbYE0NNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbYE0NNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 09:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbYE0NNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 09:13:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42473 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYE0NNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 09:13:42 -0400
Date: Tue, 27 May 2008 07:13:25 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Daniel Walker <dwalker@mvista.com>
Cc: linville@tuxdriver.com, rusty@rustcorp.com.au, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       arjan@infradead.org
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
Message-ID: <20080527131325.GJ30894@parisc-linux.org>
References: <20080522232103.120033152@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522232103.120033152@mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 04:21:03PM -0700, Daniel Walker wrote:
> Signed-off-by: Daniel Walker <dwalker@mvista.com>

Reviewing the driver, this really doesn't feel like a classical lock.
It feels very much ad-hoc, with most references to ->sem being
unbalanced.

The driver has a thread (airo_thread) and it seems to be trying to
synchronise against both the interrupt handler, and other threads
(calling eg ->get_stats).

I think it really wants to be using spin_lock_irqsave() instead of a
mutex.  I'd want to study the driver in a lot more detail before making
that kind of change though.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
