Return-Path: <linux-kernel-owner+w=401wt.eu-S1423026AbXBIMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423026AbXBIMh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423038AbXBIMh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:37:27 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:36825 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423026AbXBIMh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:37:26 -0500
Date: Fri, 9 Feb 2007 13:34:41 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: David Rientjes <rientjes@google.com>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0702091330380.31955@yvahk01.tjqt.qr>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702082202180.24888@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702081324090.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081432320.27603@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081528070.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702081554380.29559@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0702081632200.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 8 2007 16:42, Linus Torvalds wrote:
>
>Most C types don't, and some you can't even tell (do pointers generate 
>"signed" or "unsigned" comparisons?

I'd say "neither", because both

    signed void *ptr; and
    unsigned void *xyz;

are impossible (and dull at that). That's why you explicitly will
have to cast one operand in a comparison to make it evident
what sort of comparison is intended, i.e.

    if((unsigned long)ptr < PAGE_OFFSET)

Further, giving again answer to the question whether they generate signed or
unsigned comparisons: Have you ever seen a computer which addresses memory with
negative numbers? Since the answer is most likely no, signed comparisons would
not make sense for me.

> I'll argue that a compiler that 
>generates signed comparisons for them is broken, but it tends to be 
>something you can only see with a standards- conforming proghram if you 
>can allocate memory across the sign boundary, which may or may not be 
>true..)

Jan
-- 
ft: http://freshmeat.net/p/chaostables/
