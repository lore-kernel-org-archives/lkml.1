Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXBBDaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXBBDaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 22:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXBBDaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 22:30:05 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:37974 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXBBDaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 22:30:02 -0500
Date: Fri, 2 Feb 2007 09:05:20 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion system calls
Message-ID: <20070202033520.GA10412@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <patchbomb.1170193181@tetsuo.zabbo.net> <p73abzzpo75.fsf@bingen.suse.de> <63FDFD68-EE2B-4BB7-B624-513243B87634@oracle.com> <200701311821.59579.ak@suse.de> <FA06EB13-4BF6-4E3A-B223-6494079F541F@oracle.com> <20070201111307.GA24723@in.ibm.com> <4D9CAE22-C038-41C2-965F-48B7D38F0E02@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9CAE22-C038-41C2-965F-48B7D38F0E02@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 02:18:55PM -0800, Zach Brown wrote:
> >Wooo ...hold on ... I think this is swinging out of perspective :)
> 
> I'm sorry, but I don't.  I think using the EIOCBRETRY method in  
> complicated code paths requires too much maintenance cost to justify  
> its benefits.  We can agree to disagree on that judgement :).

I don't disagree about limitations of the EIOCBRETRY approach, nor do I
recommend it for all sorts of complicated code paths. It is only good as
an approximation for specific blocking points involving idempotent 
behaviour, and I was trying to emphasise that that is *all* it was ever
intended for. I certainly do not see it as a viable path to make all syscalls
asynchronous, or to address all blocking points in filesystem IO.

And I do like the general direction of your approach, only need to think
deeper about the details like how to reduce stack per IO request so this
can scale better. So we don't disagree as much as you think :)

The point where we seem to disagree is that I think there is goodness in
maintaining the conceptual clarity between what parts of the operation assume
that it is executing in the original submitters context. For the IO paths
this is what allows things like readahead and writeback to work and to cluster
operations which may end up to/from multiple submitters. This means that
if there is some context that is needed thereafter it could be associated
with the IO request (as an argument or in some other manner), so that this
division is still maintained.

Regards
Suparna

> 
> - z
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-aio' in
> the body to majordomo@kvack.org.  For more info on Linux AIO,
> see: http://www.kvack.org/aio/
> Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

