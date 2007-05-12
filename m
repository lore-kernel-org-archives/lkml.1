Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbXELLZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbXELLZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbXELLZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:25:42 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:38686 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbXELLZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:25:41 -0400
Date: Sat, 12 May 2007 13:21:41 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Matt Mackall <mpm@selenic.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, michal.k.k.piotrowski@gmail.com
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
In-Reply-To: <20070510153832.GQ11115@waste.org>
Message-ID: <Pine.LNX.4.61.0705121320240.9570@yvahk01.tjqt.qr>
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com>
 <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com>
 <46426194.3040403@goop.org> <20070510004918.GS85884050@sgi.com>
 <46426D31.8070000@goop.org> <20070510012609.GU85884050@sgi.com>
 <46433049.4020003@goop.org> <20070510153832.GQ11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 10:38, Matt Mackall wrote:
>> 
>>     for i in `seq 20`; do
>>     	hg clone -U --pull a b-$i
>>     	hg verify b-$i		# always OK
>>     	umount /home
>>     	sleep 5
>>     	mount /home
>>     	hg verify b-$i		# often found truncated files
>>     done
>>       
[...]
>
>This test looks like it should consist solely of open-for-append and
>write on about 20k files in the target directory. Because of the
>--pull, no hardlinks are involved. It shouldn't be all that different
>from doing tar cf - a | tar xf - b.
>
>The files get visited in alphabetical order, so the start of the
>corruption may be telling.

You should not assume alphabetical order. Filesystems may be free to
reorder things and return them (1) randomly like in a hash (2) by
creation time during readdir().


	Jan
-- 
