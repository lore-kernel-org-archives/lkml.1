Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbXCQC3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbXCQC3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 22:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXCQC3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 22:29:18 -0400
Received: from mail26.syd.optusnet.com.au ([211.29.133.167]:57772 "EHLO
	mail26.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753563AbXCQC3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 22:29:17 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: RSDL v0.31
Date: Sat, 17 Mar 2007 13:51:47 +1100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703170040.48316.kernel@kolivas.org> <200703170055.30747.a1426z@gawab.com>
In-Reply-To: <200703170055.30747.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703171351.47399.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 08:55, Al Boldi wrote:
> Con Kolivas wrote:
> > Here are full patches for rsdl 0.31 for various base kernels. A full
> > announce with a fresh -mm series will follow...
> >
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.20.3-rsdl-0.31.patch
>
> Thanks!  It looks much better now.

Thank you. You should find most of your latency concerns you brought up have 
been addressed by this change.

> With X nice'd at -10, and 11 hogs loading the cpu, interactivity looks good
> until the default timeslice/quota is exhausted and slows down.  Maybe
> adjusting this according to nice could help.

Not sure what you mean by that. It's still a fair distribution system, it's 
just that nice -10 has quite a bit more cpu allocated than nice 0. Eventually 
if you throw enough load at it it will slow down too.

> It may also be advisable to fix latencies according to nice, and adjust
> timeslices instead.  This may help scaleability a lot, as there are some
> timing sensitive apps that may crash under high load.

You will find that is the case already with this version. Even under heavy 
load if you were to be running one server niced (say httpd nice 19 in the 
presence of mysql nice 0) the latencies would be drastically reduced compared 
to mainline behaviour. I am aware this becomes an issue for some heavily 
loaded servers because some servers run multithreaded while others do not, 
forcing the admins to nice their multithreaded ones. 

> Thanks!
>
> --
> Al

-- 
-ck
