Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZLWIbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZLWIbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZLWIbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:31:12 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50814 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZLWIbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:31:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B0Y6vnZk5k42qzGPb/Uf1TWOXIRvlqW49Lr9AVf4Xx2uNVZtnmp/e31aAnvLEq+jdB
         3DfuDLj+ALKDm5Y0Q94DDEbYP89LER48/OW4DZkKVnYmVLgFqMu/JspNH81u90ihHiZB
         u+gY4mLrn8X+BatQS8jmhnUyqjNjljhZI+0bc=
MIME-Version: 1.0
In-Reply-To: <4B3009DC.7020407@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop> <4B2EE5A5.2030208@kernel.org>
	 <1261387377.4314.37.camel@laptop> <4B2F7879.2080901@kernel.org>
	 <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org>
Date: Wed, 23 Dec 2009 09:31:08 +0100
Message-ID: <c76f371a0912230031r5f0fd892hc814ae7a0305792f@mail.gmail.com>
Subject: Re: workqueue thing
From: Stijn Devriendt <highguy@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, dhowells@redhat.com,
       arjan@linux.intel.com, a@jasper.es
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 12:50 AM, Tejun Heo <tj@kernel.org> wrote:
>>  2) doesn't deal with cpu heavy tasks/wakeup parallelism
>
> workqueue was never suited for this.  MT workqueues have strong CPU
> affinity which doesn't make sense for CPU-heavy workloads.

It does, really. Have a look at TBB and others. You always want to keep
workqueue items as close to the scheduling thread as possible as the
chance of having a hot cache and TLBs and such are far greater.
The end result is CPU-affine threads fetching work from CPU-affine
queues with workitems scheduled by a thread on that CPU.
To improve parallellism, workqueue threads with empty workqueues
start stealing work away from non-empty workqueues.
The added warmup doesn't weigh in against the added parallellism
in those cases.

Stijn
