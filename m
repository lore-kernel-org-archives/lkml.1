Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbYDTDHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbYDTDHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 23:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYDTDHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 23:07:31 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1125 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbYDTDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 23:07:31 -0400
Subject: Re: Alternative implementation of the generic __ffs
From: Joe Perches <joe@perches.com>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080419222911.GJ3700@mea-ext.zmailer.org>
References: <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
	 <1207563950.7880.1246457209@webmail.messagingengine.com>
	 <20080418201809.GA5036@mailshack.com>
	 <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
	 <1208563762.10414.19.camel@brick>
	 <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>
	 <1208566724.4891.25.camel@localhost> <1208567093.10414.20.camel@brick>
	 <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org>
	 <1208573728.11990.14.camel@localhost>
	 <20080419222911.GJ3700@mea-ext.zmailer.org>
Content-Type: text/plain
Date: Sat, 19 Apr 2008 20:06:57 -0700
Message-Id: <1208660817.12388.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-20 at 01:29 +0300, Matti Aarnio wrote:
> I am curious, why not take the code already in glibc ffs() for ARM ?
> That is, if the ffs() is all that important detail in kernel ?

Here's test results with the glibc ffs implementation.
(small const is still using slower add rather than or)

$ gcc -Os -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3155 tics,  8331 tics
New:            4211 tics,  8793 tics
Smallest:       4019 tics,  7754 tics
Small const:    3552 tics,  6308 tics
glibc:          2816 tics,  6911 tics
Empty loop:     1516 tics,  2244 tics

$ gcc -O2 -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3155 tics,  7828 tics
New:            4792 tics,  8825 tics
Smallest:       4401 tics,  7155 tics
Small const:    3539 tics,  5805 tics
glibc:          2720 tics,  7061 tics
Empty loop:     1516 tics,  2148 tics

$ gcc -O3 -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3080 tics,  7706 tics
New:            4721 tics,  8663 tics
Smallest:       4334 tics,  7116 tics
Small const:    3466 tics,  5672 tics
glibc:          2649 tics,  6939 tics
Empty loop:     1444 tics,  2012 tics


