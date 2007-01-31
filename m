Return-Path: <linux-kernel-owner+w=401wt.eu-S933228AbXAaRvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbXAaRvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXAaRvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:51:33 -0500
Received: from kanga.kvack.org ([66.96.29.28]:46864 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228AbXAaRvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:51:32 -0500
Date: Wed, 31 Jan 2007 12:51:18 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
Message-ID: <20070131175118.GN1344@kvack.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <6CDD5D9D-E031-499D-9A8A-5A8522C66D37@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6CDD5D9D-E031-499D-9A8A-5A8522C66D37@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 09:38:11AM -0800, Zach Brown wrote:
> Indeed, that was my first reaction too.  I dismissed the idea for a  
> good six months after initially realizing that it implied sharing  
> journal_info, etc.
> 
> But when I finally sat down and started digging through the  
> task_struct members and, after quickly dismissing involuntary  
> preemption of the fibrils, it didn't seem so bad.  I haven't done an  
> exhaustive audit yet (and I won't advocate merging until I have) but  
> I haven't seen any train wrecks.

I'm still of the opinion that you cannot do this without creating actual 
threads.  That said, there is room for setting up the task_struct beforehand 
without linking it into the system lists.  The reason I don't think this 
approach works (and I looked at it a few times) is that many things end 
up requiring special handling: things like permissions, signals, FPU state, 
segment registers....  The list ends up looking exactly the way task_struct 
is, making the actual savings very small.

What the fibrils approach is useful for is the launching of the thread 
initially, as you don't have to retain things like the current FPU state, 
change segment registers, etc.  Changing the stack is cheap, the rest of 
the work is not.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.
