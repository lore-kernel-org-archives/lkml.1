Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYCaD1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYCaD1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 23:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbYCaD1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 23:27:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbYCaD1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 23:27:25 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] do_wait reorganization
In-Reply-To: Linus Torvalds's message of  Saturday, 29 March 2008 09:16:02 -0700 <alpine.LFD.1.00.0803290906050.14670@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080329033412.120EE26FA1D@magilla.localdomain>
	<alpine.LFD.1.00.0803290906050.14670@woody.linux-foundation.org>
X-Zippy-Says: Here I am in the POSTERIOR OLFACTORY LOBULE but I don't see CARL
    SAGAN anywhere!!
Message-Id: <20080331032717.A269626F8E9@magilla.localdomain>
Date: Sun, 30 Mar 2008 20:27:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I also wonder if you really need both "int *retval" and the return value. 
> Isn't "retval" always going to be zero or a negative errno? 

No.

> And the return value is going to be either true of false?

Yes.

> Why not just fold them into one single thing:
> 
>  - negative: all done, with error
>  - zero: this didn't trigger, continue with the next one in caller
>  - positive: this thread triggered, all done, return 0 in the caller.
> 
> which is (I think) close to what we already do in eligible_child() (so 
> this would not be a new calling convention for this particular code).

You listed the three possibilities for eligible_child().
For wait_consider_task(), there are four possibilities:

 - all done, with error
 - this thread was not eligible, look for another; return -ECHILD if none ready
 - this thread was eligible but is not ready; return 0 or block if none ready
 - all done, this thread is ready; return its pid

I'll post another version that I think you'll like a little better.


Thanks,
Roland
