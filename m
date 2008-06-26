Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYFZTUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYFZTUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbYFZTTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:19:53 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:10673 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754189AbYFZTTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:19:17 -0400
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to
	rebuild_sched_domains() to the workqueue
From: Peter Zijlstra <peterz@infradead.org>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul Menage <menage@google.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Jackson <pj@sgi.com>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <4863E4C8.9050705@qualcomm.com>
References: <48634BC1.8@google.com>
	 <19f34abd0806260234y7616bab2k54bc019dfb0c6305@mail.gmail.com>
	 <6599ad830806260250m39d700a5haf0f32d999cd2129@mail.gmail.com>
	 <4863E4C8.9050705@qualcomm.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 21:19:05 +0200
Message-Id: <1214507945.12265.7.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 11:49 -0700, Max Krasnyansky wrote:

> > Does that mean that you can't ever call get_online_cpus() from a
> > workqueue thread?
> 
> In general it should be ok (no different from user-space task calling 
> it). But there is still circular dependency because we're calling into
> domain partitioning code.
> Below is more detailed lockdep report with your patch applied on top of 
> -rc8.
> Looks like this might be a good time to rethink overall locking in there.

Gautham has been working on some of this recently. Perhaps he can share
his patch-stack again.



