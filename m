Return-Path: <linux-kernel-owner+w=401wt.eu-S1765651AbXE2ULt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765651AbXE2ULt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760374AbXE2ULl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:11:41 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54543 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbXE2ULk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:11:40 -0400
Date: Tue, 29 May 2007 22:10:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Linux always started with 9600 8N1
In-Reply-To: <20070527.144702.55507425.davem@davemloft.net>
Message-ID: <Pine.LNX.4.61.0705292208380.11140@yvahk01.tjqt.qr>
References: <20070526.154745.30164056.davem@davemloft.net>
 <Pine.LNX.4.61.0705271816310.7344@yvahk01.tjqt.qr> <20070527.141622.30184020.davem@davemloft.net>
 <20070527.144702.55507425.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 27 2007 14:47, David Miller wrote:
>
>> So even writes to so-called 'read-only' sections of the kernel image
>> will work and therefore I don't understand what the bug could be other
>> than the compiler "optimizing" away the write to the constant string
>> in which case the compiler should have warned about it.
>
>I just stared at the drivers/serial/suncore.s assembler a little
>bit and this is indeed what appears to be happening, the compiler
>is optimizing the stores away completely yet not doing so much
>as emitting a warning, how rude :-)

I do not think it can throw a meaningful warning. After all, whether
dereferencing and writing to a char* actually touches

(a) rw memory
(b) ro memory
(c) rw memory which we'd like to be ro ;-)

is not known to the compiler. Of course, one may add more complicated
code to cover simple cases like the one in suncore.c, but that may
as well just gives us more can't-figure-out-correctly-on-my-own warnings
like "possible uninitialized value used" (int n; set_n(&n); use_n(n);) /
where adding more code to cover all detectable cases increases complexity
too much.


	Jan
-- 
