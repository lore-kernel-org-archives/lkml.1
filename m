Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYHZGVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYHZGVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 02:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYHZGVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 02:21:41 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:29029 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751365AbYHZGVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 02:21:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=InUqp9/4JxVaGKca/LPH2BAKa4kGIVd81poR/YBrSB2jkGLECi8gcP0GcTSNTDaXc261ow7HpwRQh3NvPeIJYcV3+DMiOwTwOcXbTjwK0ro2hcgnT5wJlatZBzTInd9pOFinV55M8KWekXrWttQk1O4OgwJdJcp4L8FftEGb1f4=  ;
X-YMail-OSG: tj_KE7cVM1mCq2lGHQLfnnAEROGfvhGx3Xh1OlG8.rHJH1EzSnw4nYt8sU2HiDfb2urWwCJXh960kSBY4KKeWfeh4hiuSKQIVIM.b826TT8f5W.T6aN3ReKGNdeSA5EzmuJ8au6H.mg3orAxNN9j9EDX
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH 2/5] sched: pull only one task during NEWIDLE balancing to limit critical section
Date: Tue, 26 Aug 2008 16:21:33 +1000
User-Agent: KMail/1.9.5
Cc: mingo@elte.hu, srostedt@redhat.com, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de, gregory.haskins@gmail.com
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <20080825201529.23217.8708.stgit@dev.haskins.net>
In-Reply-To: <20080825201529.23217.8708.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261621.33810.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 06:15, Gregory Haskins wrote:
> git-id c4acb2c0669c5c5c9b28e9d02a34b5c67edf7092 attempted to limit
> newidle critical section length by stopping after at least one task
> was moved.  Further investigation has shown that there are other
> paths nested further inside the algorithm which still remain that allow
> long latencies to occur with newidle balancing.  This patch applies
> the same technique inside balance_tasks() to limit the duration of
> this optional balancing operation.
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Nick Piggin <npiggin@suse.de>

Hmm, this (andc4acb2c0669c5c5c9b28e9d02a34b5c67edf7092) still could
increase the amount of work to do significantly for workloads where
the CPU is going idle and pulling tasks over frequently. I don't
really like either of them too much.

Maybe increasing the limit would effectively amortize most of the
problem (say, limit to move 16 tasks at most).
