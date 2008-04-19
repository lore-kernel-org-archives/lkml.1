Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbYDSSR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbYDSSR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYDSSRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:17:50 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4670 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbYDSSRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:17:50 -0400
Subject: Re: Alternative implementation of the generic __ffs
From: Joe Perches <joe@perches.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: dean gaudet <dean@arctic.org>, Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1208607019.13829.1248748343@webmail.messagingengine.com>
References: <20080331171506.GA24017@mailshack.com>
	 <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com>
	 <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
	 <1207507897.18129.1246358115@webmail.messagingengine.com>
	 <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
	 <1207563950.7880.1246457209@webmail.messagingengine.com>
	 <20080418201809.GA5036@mailshack.com>
	 <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
	 <1208563762.10414.19.camel@brick>
	 <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>
	 <1208566724.4891.25.camel@localhost> <1208567093.10414.20.camel@brick>
	 <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org>
	 <1208573728.11990.14.camel@localhost>
	 <alpine.DEB.1.10.0804182112360.6108@twinlark.arctic.org>
	 <1208607019.13829.1248748343@webmail.messagingengine.com>
Content-Type: text/plain
Date: Sat, 19 Apr 2008 11:17:01 -0700
Message-Id: <1208629021.12388.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-19 at 14:10 +0200, Alexander van Heukelum wrote:
> I've added that to the benchmark, which you can now find here:
> http://heukelum.fastmail.fm/ffs/.

retested on arm:

$ gcc -Os -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3170 tics,  8326 tics
New:            4214 tics,  8793 tics
Smallest:       4023 tics,  7733 tics
Small const:    3442 tics,  6188 tics
Empty loop:     1517 tics,  2243 tics

$ gcc -O2 -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3172 tics,  7832 tics
New:            4805 tics,  8790 tics
Smallest:       4405 tics,  7154 tics
Small const:    3442 tics,  5612 tics
Empty loop:     1516 tics,  2145 tics

$ gcc -O3 -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3080 tics,  7709 tics
New:            4723 tics,  8656 tics
Smallest:       4333 tics,  7121 tics
Small const:    3379 tics,  5483 tics
Empty loop:     1447 tics,  2016 tics

>  Testing the same with 
> "return x4 + x3 + x2 + x1 + x0;" as the last line would be
> interesting too.

Adding is slower:

$ gcc -Os -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3152 tics,  8310 tics
New:            4214 tics,  8789 tics
Smallest:       4024 tics,  7737 tics
Small const:    3538 tics,  6295 tics
Empty loop:     1517 tics,  2243 tics

$ gcc -O2 -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3184 tics,  7849 tics
New:            4790 tics,  8814 tics
Smallest:       4406 tics,  7161 tics
Small const:    3538 tics,  5806 tics
Empty loop:     1521 tics,  2153 tics

$ gcc -O3 -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3091 tics,  7694 tics
New:            4718 tics,  8656 tics
Smallest:       4333 tics,  7124 tics
Small const:    3467 tics,  5687 tics
Empty loop:     1445 tics,  2066 tics


