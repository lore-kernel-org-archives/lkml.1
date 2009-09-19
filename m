Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZISJSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZISJSG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZISJSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:18:05 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:54398 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZISJSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:18:04 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: INGO Why you remove set_user_nice() from kernel/kthread.c
Content-Disposition: inline
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux Inc.
X-Face: =?iso-8859-1?q?=2EqZWJ=3F=248Zrl=26r=7C-=3B8=7ESTufc!R0d=5E=3FdE-g/S=5FryU?=
 =?iso-8859-1?q?2S=5D=27=24vQ7EYY=3DBSj=5DJ-Gp=5FVXPpl=27ci/i=0A=09yH=5B=24?=
 =?iso-8859-1?q?9HGUU=3Af?=@6hyHiQKeEv#S(K4XtVe$?0UO@',
 =?iso-8859-1?q?!=25=5CR=3A7a=3BITA=3B=7Cs=7C=3F=25+T6=7E5=3Aq=2E2i=5Dz?=
 =?iso-8859-1?q?A=25=0A=09Mn-t3kOWGQ?=(7@ZOZ/0@+baHY#Fj&e/k'#p}#F<U{[DP[@"XbG&pmU~{oOMsPc4q|4/,
 =?iso-8859-1?q?du8=0A=09?="'s*i`2=h[f!7!`#',39O3
Date: Sat, 19 Sep 2009 13:18:01 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909191318.02670.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 September 2009 13:13:31 you wrote:
> Pavel,
>
> On Mon, 14 Sep 2009, Pavel Vasilyev wrote:
> >  ----------
> >  CYCLE TEST
> >  ----------
> >
> > -T: 0 ( 5263) P: 0 I:1000 C:  98345 Min:      8 Act:656014 Avg:287390
> > Max: 656450
> > -T: 1 ( 5264) P: 0 I:1500 C:  65680 Min:      7 Act:481583 Avg:236140
> > Max: 482343
> > -T: 2 ( 5265) P: 0 I:2000 C:  49358 Min:      7 Act:286071 Avg:111300
> > Max: 287453
> > -T: 3 ( 5266) P: 0 I:2500 C:  39453 Min:      7 Act:370028 Avg:116111
> > Max: 372481
> > +T: 0 ( 6634) P: 0 I:1000 C:  98888 Min:      7 Act:113011 Avg:28733 Max:
> > 113817
> > +T: 1 ( 6635) P: 0 I:1500 C:  65953 Min:      8 Act:72013 Avg:25026 Max:
> > 73110
> > +T: 2 ( 6636) P: 0 I:2000 C:  49468 Min:      6 Act:66076 Avg:17455 Max:
> > 67486
> > +T: 3 ( 6637) P: 0 I:2500 C:  39580 Min:      7 Act:52514 Avg:12882 Max:
> > 53256
> >
> >  ----------
> >  SIGNAL TEST
> >  ----------
> >
> > -T: 0 ( 5285) P: 0 C: 100000 Min:     13 Act:   23 Avg:   30 Max:    9229
> > -T: 1 ( 5286) P: 0 C: 100000 Min:     13 Act:   99 Avg:  662 Max:   17282
> > -T: 2 ( 5287) P: 0 C: 100000 Min:     13 Act:  110 Avg:  662 Max:   17294
> > -T: 3 ( 5288) P: 0 C: 100000 Min:     13 Act:  119 Avg:  662 Max:   18645
> > +T: 0 ( 6698) P: 0 C: 100000 Min:     13 Act:   22 Avg:   24 Max:    7898
> > +T: 1 ( 6699) P: 0 C: 100000 Min:     13 Act:  104 Avg:  654 Max:   15728
> > +T: 2 ( 6700) P: 0 C: 100000 Min:     13 Act:  114 Avg:  654 Max:   15740
> > +T: 3 ( 6701) P: 0 C: 100000 Min:     13 Act:  124 Avg:  654 Max:   16102
>
> These comparisons are not telling anything without the used command
> line options and a description of the load on the machine while
> running the tests.
>

# ./cyclictest -t -b -o -D 100s -w -q
# ./signaltest -t4 -l 100000 -q

# cat /proc/cpuinfo  | grep "model name"
model name      : Dual Core AMD Opteron(tm) Processor 265
model name      : Dual Core AMD Opteron(tm) Processor 265
model name      : Dual Core AMD Opteron(tm) Processor 265
model name      : Dual Core AMD Opteron(tm) Processor 265

# Linux amd64 2.6.31 #15 SMP PREEMPT Thu Sep 17 00:04:02 MSD 2009 x86_64 
x86_64 x86_64 GNU/Linux

