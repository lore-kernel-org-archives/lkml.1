Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZCIOmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZCIOmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 10:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbZCIOmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 10:42:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59682 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZCIOmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 10:42:09 -0400
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Balazs Scheidler <bazsi@balabit.hu>,
       linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <1236607890.6168.7.camel@marge.simson.net>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
	 <20090309080714.GB24904@elte.hu>  <1236596664.8389.331.camel@laptop>
	 <1236604563.6027.8.camel@marge.simson.net>
	 <1236605870.6515.5.camel@marge.simson.net>
	 <1236606389.8389.518.camel@laptop>
	 <1236607083.5980.8.camel@marge.simson.net>
	 <1236607890.6168.7.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 15:41:51 +0100
Message-Id: <1236609711.8389.583.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 15:11 +0100, Mike Galbraith wrote:

> > Yes 2* worked fine.  Mysql+oltp was my worry spot, being a very affinity
> > sensitive little <bleep>, but my patchlet didn't cause any trouble, so
> > this one shouldn't either.  I'll do some re-test in any case, and squeak
> > should anything turn up.
> 
> Squeak!  Didn't even get to mysql+oltp.
> 
> marge:..local/tmp # netperf -t UDP_STREAM -l 60 -H 127.0.0.1  -- -P 15888,12384 -s 32768 -S 32768 -m 4096
> UDP UNIDIRECTIONAL SEND TEST from 0.0.0.0 (0.0.0.0) port 15888 AF_INET to 127.0.0.1 (127.0.0.1) port 12384 AF_INET
> Socket  Message  Elapsed      Messages
> Size    Size     Time         Okay Errors   Throughput
> bytes   bytes    secs            #      #   10^6bits/sec
> 
>  65536    4096   60.00     5161103      0    2818.65
>  65536           60.00     5149666           2812.40
> 
>  6188 root      20   0  1040  544  324 R  100  0.0   0:31.49 0 netperf
>  6189 root      20   0  1044  260  164 R   48  0.0   0:15.35 3 netserver
> 
> Hurt, pain, ouch, vs...
> 
> marge:..local/tmp # netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -T 0,0 -- -P 15888,12384 -s 32768 -S 32768 -m 4096
> UDP UNIDIRECTIONAL SEND TEST from 0.0.0.0 (0.0.0.0) port 15888 AF_INET to 127.0.0.1 (127.0.0.1) port 12384 AF_INET : cpu bind
> Socket  Message  Elapsed      Messages
> Size    Size     Time         Okay Errors   Throughput
> bytes   bytes    secs            #      #   10^6bits/sec
> 
>  65536    4096   60.00     8452028      0    4615.93
>  65536           60.00     8442945           4610.97
> 
> Drat.

Bugger, so back to the drawing board it is...

