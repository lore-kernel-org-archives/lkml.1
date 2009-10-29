Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbZJ2Aoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbZJ2Aoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZJ2Aoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:44:37 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:56991 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZJ2Aog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:44:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-type:subject:from:to:in-reply-to:references:date:message-id
         :user-agent:content-transfer-encoding;
        b=VdSQAT/+GQEbCa3mMBTuhsqhE+Pt1hBn/y4NxClBe/9AlMe/i26LZAeoYfB/chhV0P
         +/SpevcUuZ8uvGUJ61yPuW0v/YJ1vepA+V4CWZ0UhbvglOcgumruc+IghLXE0d3XBdjl
         6Pmnq69mpz5I9HL9Hlit+rzB5vKBuqOUqycAE=
Content-Type: text/plain; charset=UTF-8
Subject: Re: Hyperthreading on 4 core CPU DECREASES performance???
From: Ben Gamari <bgamari.foss@gmail.com>
To: ichudov <ichudov@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
In-reply-to: <e86b7d350910281700x1383296i73cd1ee4694e9c8@mail.gmail.com>
References: <e86b7d350910281224i7e91a1ecp9f3d15d9c36f19cb@mail.gmail.com> <20091028222439.3e0be650@lxorguk.ukuu.org.uk> <e86b7d350910281700x1383296i73cd1ee4694e9c8@mail.gmail.com>
Date: Wed, 28 Oct 2009 20:44:38 -0400
Message-Id: <1256777051-sup-2265@ben-laptop>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Igor Chudov's message of Wed Oct 28 20:00:10 -0400 2009:
> On Wed, Oct 28, 2009 at 5:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > The win from HT depends a lot on the CPU and also the workload mix. In
> > some workloads it will decrease performance.
> 
> OK, I think that I understand. Thanks.
> 
> So, what you are basically saying is that there is no option to
> improve this behavior, right?
> 
He was saying (correct me if I'm wrong) that SMT isn't necessarily a
win. For some workloads that utilize a variety of variety of processor
resources, Hyperthreading can help extract parellelism and improve
overall pipeline utilization.  In many types of workloads, however, this
increased parallelism only results in increased cache, and TLB thrashing
and bandwidth contention. If your workload has a large cache footprint,
this will probably be a significant consideration. This problem is a
problem intrinsic to SMT and outside of the usual scheduling
considerations for cache-friendliness, there is little that the kernel
can do.

Whoever wrote that intelligent handling of multiple cores was a done
deal was lying. Certainly, the kernel is very good at scheduling
multiple cores, but using them in a way to extract performance is
completely up to the application and is by no means an easy task.

- Ben
