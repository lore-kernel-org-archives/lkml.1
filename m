Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZINP3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZINP3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZINP3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:29:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZINP3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:29:03 -0400
Subject: Re: Trace event testing time - 3s to 41s
From: Steven Rostedt <srostedt@redhat.com>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <f7848160909130815l3e768a30n3b28808bbe5c254b@mail.gmail.com>
References: <f7848160909130815l3e768a30n3b28808bbe5c254b@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 14 Sep 2009 11:28:50 -0400
Message-Id: <1252942130.2964.148.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-13 at 11:15 -0400, Parag Warudkar wrote:
> Somewhere between -rc9 and yesterday's git, my desktop went from using
> 3s worth of trace event testing time to 41s !
> 
> It looks like we not only added a whole bunch of tracing points but
> also are doing the tests twice post -rc9 - the addition being testing
> with function tracer.
> 
> grep "Testing event" dmesg.31rc9 |wc -l
> 100
> 
> grep "Testing event" dmesg.31git |wc -l
> 1172

This was due to the fact that we test every syscall now.

> 
> While one could get away with "don't enable that config option then"
> response, for testing kernels daily this sounds like it is going to be
> very annoying as it adds a considerable boot lag.
> 
> So I was thinking could we move this testing to a kthread with idle
> priority or something - may be disabling tracing until those tests are
> finished, if that sort of thing is necessary?
> Or does it need to happen synchronous to booting?

I don't have time at the moment, but I would not mind moving the syscall
testing to a thread. Heck, that way we can actually test syscalls
too ;-)

-- Steve


