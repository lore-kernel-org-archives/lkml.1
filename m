Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbYI3HDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbYI3HDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYI3HDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:03:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57923 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbYI3HDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:03:36 -0400
Date: Tue, 30 Sep 2008 12:33:26 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH] sched: minor optimizations in wake_affine and
	select_task_rq_fair
Message-ID: <20080930070326.GA5331@amitarora.in.ibm.com>
References: <20080929100227.GA21129@amitarora.in.ibm.com> <48E0FDC5.1080500@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E0FDC5.1080500@nortel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 10:09:41AM -0600, Chris Friesen wrote:
> Amit K. Arora wrote:
>> sched: Minor optimizations in wake_affine and select_task_rq_fair
>>
>> This patch does following:
>> o Reduces the number of arguments to wake_affine().
>
> At what point is it cheaper to pass items as args rather than recalculating 
> them?  If reducing the number of args is desirable, what about removing the 
> "this_cpu" and "prev_cpu" args and recalculating them in wake_affine()?

Thats a good question. Its kind of arguable and I wasn't sure if
everyone will be happy if I removed more arguments from wake_affine() than
what I did in my patch (because of the recalculations required).

wake_affine() currently has 11 arguments and I thought it may make sense
in reducing it to a sane number. For that I chose arguments which I
thought can be recalculated with minimum overhead (involves single struct
dereference, a simple per cpu variable and/or a simple arithmetic). And
one argument ("rq") which is being removed, isn't used at all in the
function!

Regarding the two variables you have mentioned, I didn't remove them as
args since I wasn't sure of "this_cpu" (which is nothing but
smp_processor_id()) as it is arch dependent, and calculating "prev_cpu"
involves two struct dereferences (((struct thread_info *)(task)->stack)->cpu).
And the calculation for other arguments (like, this_sd, load and this_load)
involves good amount of instructions.

If you disagree, what do you suggest we do here ?

Regards,
Amit Arora
