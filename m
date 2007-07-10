Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbXGJTUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbXGJTUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbXGJTUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:20:47 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1785 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbXGJTUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:20:46 -0400
Message-ID: <4693DC0C.3050305@shadowen.org>
Date: Tue, 10 Jul 2007 20:20:44 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Martin Bligh <mbligh@mbligh.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Performance regression in 2.6.22-git1 (new sched code?)
References: <4693C3D2.9020005@mbligh.org>
In-Reply-To: <4693C3D2.9020005@mbligh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Bligh wrote:
> ~ 1% on 4-way x86_64
> 
> http://test.kernel.org/perf/kernbench.elm3b6.png
> 
> ~ 4% on 16-way NUMA-Q (i386)
> 
> http://test.kernel.org/perf/kernbench.moe.png
> 
> ~ 1.5% on 4-way i386
> 
> http://test.kernel.org/perf/kernbench.elm3b132.png
> 
> There's readprofiles and stuff available from here:
> http://test.kernel.org/functional/index.html
> if you drill down under the tests marked "regression", eg.
> http://test.kernel.org/abat/98796/002.kernbench.test/profiling/profile.text

Ok, I've done a crude comparison of a bunch of the jobs we run between
2.6.22 and 2.6.22-git1 kernbench runs, extracting the wallclock, user
and system times for each.  First column is 2.6.22, second is
2.6.22-git1, third is the delta.  +ve bad, -ve good.  Note that I have
hand correlated these jobs so error is possible, but it matches Martin's
figures I belive.

bl6-13
	User    85.14  88.53   3.99
	System  34.16  34.71   1.60
	Total  119.30 123.24   3.30
elm3b132
	User   2397.82 2431.95   1.42
	System 207.41 206.78  -0.30
	Total  2605.23 2638.73   1.29
elm3b6
	User   352.18 357.18   1.42
	System  37.06  36.61  -1.22
	Total  389.24 393.79   1.17
oia5-hs20
	User   645.02 653.47   1.31
	System  49.30  52.45   6.37
	Total  694.33 705.92   1.67
elm3b239
	User   878.21 950.80   8.27
	System 416.06 348.76 -16.18
	Total  1294.27 1299.56   0.41

-apw
