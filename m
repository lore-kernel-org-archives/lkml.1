Return-Path: <linux-kernel-owner+w=401wt.eu-S1031344AbXDZRNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031344AbXDZRNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031355AbXDZRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:13:53 -0400
Received: from www.osadl.org ([213.239.205.134]:39359 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031344AbXDZRN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:13:29 -0400
Subject: Re: recomended way to check longest period that interupts are
	disabled ?
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Mike Mattie <codermattie@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070426051953.26582bbb@reforged>
References: <20070426021350.29ddfa0a@reforged>
	 <1177581237.26937.105.camel@twins> <20070426040252.3f4fa8cc@reforged>
	 <1177585912.6815.6.camel@twins>  <20070426051953.26582bbb@reforged>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 19:15:23 +0200
Message-Id: <1177607723.25960.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 05:19 -0700, Mike Mattie wrote:
> Thanks for the comments. After running cyclictest it definitely looks
> like the average jitter is really low, around 7-8 . The max is really
> high , >100
> 
> If I am interpreting this correctly for the most part the jitter is
> pretty low, but something horrible is happening that blows up the
> max value.

Yup

> ./cyclictest -p 30 -t 6
> 2.00 1.84 1.41 3/120 13760
> 
> T: 0 (13130) P:30 I:1000 C:  42763 Min:      4 Act:   10 Avg:    8 Max:     133
> T: 1 (13131) P:29 I:1500 C:  28509 Min:      4 Act:    6 Avg:    7 Max:     114
> T: 2 (13132) P:28 I:2000 C:  21382 Min:      4 Act:    7 Avg:    6 Max:     157
> T: 3 (13133) P:27 I:2500 C:  17106 Min:      4 Act:   11 Avg:    7 Max:     110
> T: 4 (13134) P:26 I:3000 C:  14255 Min:      4 Act:    8 Avg:    7 Max:    1011
> T: 5 (13135) P:25 I:3500 C:  12218 Min:      4 Act:   12 Avg:    8 Max:     118

What happens with 

# cyclictest -p 80 -n

At first it puts the timer thread above everything else and second it
uses nanosleep instead of the signal delivered posix timers.

	tglx


