Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbXKGWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbXKGWy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXKGWyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:54:21 -0500
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:36015 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753057AbXKGWyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:54:20 -0500
Message-Id: <4731FB1B.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 07 Nov 2007 17:51:23 -0500
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "RT" <linux-rt-users@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.23.1-rt9 (and others)
References: <1194413959.8827.66.camel@localhost.localdomain>
 <Pine.LNX.4.58.0711071040210.8572@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0711071040210.8572@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, Nov 7, 2007 at 10:41 AM, in message
<Pine.LNX.4.58.0711071040210.8572@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote: 

> 
> So please compare -rt7, -rt8 and -rt10.

Here are my results from running:

sudo chrt -f 80 ./cyclictest -n -p 90 -t 8 -d 100 -i 100

with

while true; do make mrproper; make allmodconfig; make -j 128 > /dev/null; done
 on a plain kernel.org kernel

running in the background on an 8-way (4core x2) C2D Xeon 5335 system

23.1-rt7
---------------------------

  144.60 135.30 116.38 30/814 8184

  T: 0 ( 5990) P:90 I:100 C:11560415 Min:2 Act:  5 Avg: 4 Max:  83
  T: 1 ( 5991) P:89 I:200 C:5780208 Min: 2 Act:  5 Avg: 4 Max:  66
  T: 2 ( 5992) P:88 I:300 C:3853472 Min: 2 Act:  5 Avg: 5 Max:  89
  T: 3 ( 5993) P:87 I:400 C:2890104 Min: 2 Act:  6 Avg: 5 Max:  70
  T: 4 ( 5994) P:86 I:500 C:2312083 Min: 2 Act:  4 Avg: 5 Max:  91
  T: 5 ( 5995) P:85 I:600 C:1926736 Min: 2 Act:  5 Avg: 5 Max:  94
  T: 6 ( 5996) P:84 I:700 C:1651488 Min: 2 Act: 12 Avg: 5 Max: 115
  T: 7 ( 5997) P:83 I:800 C:1445052 Min: 2 Act:  6 Avg: 5 Max:  79

23.1-rt8
---------------------------
  119.95 106.56 107.98 37/811 18445

  T: 0 ( 5052) P:90 I:100 C:29592746 Min: 2 Act: 21 Avg: 4 Max:  78
  T: 1 ( 5053) P:89 I:200 C:14796374 Min: 2 Act:  6 Avg: 4 Max:  81
  T: 2 ( 5054) P:88 I:300 C:9864249 Min:  2 Act: 10 Avg: 4 Max:  88
  T: 3 ( 5055) P:87 I:400 C:7398187 Min:  2 Act:  6 Avg: 4 Max:  86
  T: 4 ( 5056) P:86 I:500 C:5918550 Min:  2 Act: 13 Avg: 9 Max:  69
  T: 5 ( 5057) P:85 I:600 C:4932125 Min:  2 Act: 11 Avg: 4 Max:  71
  T: 6 ( 5058) P:84 I:700 C:4227536 Min:  2 Act:  8 Avg: 5 Max:  65
  T: 7 ( 5059) P:83 I:800 C:3699094 Min:  2 Act:  4 Avg: 4 Max: 114

23.1-rt10
---------------------------
  143.39 123.49 117.92 22/791 5802

  T: 0 ( 5305) P:90 I:100 C:45332860 Min: 2 Act:  4 Avg: 4 Max: 89
  T: 1 ( 5306) P:89 I:200 C:22666431 Min: 2 Act:  3 Avg: 5 Max: 49
  T: 2 ( 5307) P:88 I:300 C:15110954 Min: 2 Act:  6 Avg: 5 Max: 76
  T: 3 ( 5308) P:87 I:400 C:11333216 Min: 2 Act:  7 Avg: 5 Max: 81
  T: 4 ( 5309) P:86 I:500 C:9066572 Min:  2 Act:  8 Avg: 5 Max: 57
  T: 5 ( 5310) P:85 I:600 C:7555477 Min:  2 Act:  8 Avg: 5 Max: 55
  T: 6 ( 5311) P:84 I:700 C:6476123 Min:  2 Act: 14 Avg: 6 Max: 73
  T: 7 ( 5312) P:83 I:800 C:5666608 Min:  2 Act:  5 Avg: 6 Max: 78

note that the rt10 image was running for a much longer duration than the other two...which generally will push the max higher.  I know in general if I let -rt7 go that long it will hit 120-150+.  This means these tests were biased towards -rt7 and -rt8 performing better, but they still came in with higher latencies.

I will officially test -rt11 next, tho in my small runs so far it looks great.

HTH

Regards,
-Greg

