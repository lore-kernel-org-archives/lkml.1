Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZG1Ky1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZG1Ky1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZG1Ky1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:54:27 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:25287 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZG1Ky0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:54:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counter: Track all mmaps, heap and stack extensions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, paulus@samba.org, fweisbec@gmail.com, rdreier@cisco.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090728084612.GA4603@kryten>
References: <20090728084612.GA4603@kryten>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 12:57:02 +0200
Message-Id: <1248778622.6987.2983.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 18:46 +1000, Anton Blanchard wrote:
> Hi,
> 
> Right now perf_counter only logs executable mmaps. While this is enough
> for instruction profiling, at some stage we are also going to want
> to do data profiling. This will require us to log non-executable mmaps as
> well as stack and heap extensions.
> 
> Why would we care about heap and stack? A few examples:
> 
> 1. We can monitor TLB miss rates to suggest what regions of memory should be
>    put into hugepages.
>  
> 2. We can look into various TLB miss issues. On PowerPC a data prefetch
>    that goes to an unmapped area takes a significant amount of time (it
>    initiates a tablewalk that may take 40+ cycles). With accurate mapping
>    data we can catch areas of code with bad prefetch instructions.

Agreed.

> Taking it a bit further, since in some sense perf_counter is a channel for
> getting events out to userspace, I wonder if we could solve Roland's RDMA
> address space unmap issue with perf_counter:
> 
> http://patchwork.kernel.org/patch/37267/

Yeah, saw some of that, Andrew has some good points there. Haven't had
time to see the reply yet.

Not sure its a good match, but if so, very nice.

> Below is a dodgy hack I've been using to prototype tracking of all mmaps
> and heap/stack extensions. Naturally we'd want a perf_counter feature to turn
> this on and keep instruction profiles more compact. We'd also want munmap
> events.

I used to have an munmap hook in there at some point. We could restore
that.

> Thoughts?

Seems like a good direction, go for it ;-)


