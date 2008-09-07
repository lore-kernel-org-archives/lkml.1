Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYIGN6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYIGN6X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 09:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYIGN6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 09:58:11 -0400
Received: from japan.chezphil.org ([77.240.5.4]:3624 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbYIGN6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 09:58:11 -0400
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Sun, 07 Sep 2008 14:58:08 +0100
Subject: Re: nice and hyperthreading on atom
Message-ID: <1220795888167@dmwebmail.dmwebmail.chezphil.org>
In-Reply-To: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
References: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phil Endecott wrote:
> Dear Experts,
>
> I have an ASUS Eee with an Atom processor, which has hyperthreading 
> enabled.  If I have two processes, one nice and the other normal, they 
> each get 50% of the CPU time.  Of course this is what you'd expect if 
> the scheduler didn't understand that the two virtual processors are not 
> really independent.  I'd like to fix it.

I thought I'd try to quantify the effect with real processes.  My 
"foreground" task is a compilation and my "background" task is a tight 
loop at nice -9.  No doubt you would get different results with 
different tasks (amount of I/O, cache hit rate, different nice level etc.).

With no background task running, the foreground task takes 86s whether 
or not HT is enabled.  With the background task running, the foreground 
task takes 97s with HT off and 104s with HT on.  104s is better than I 
was expecting; in fact it's close enough to 97s that the problem can be 
overlooked in this case.

I made a number of other measurements, of which the most significant is 
that the run time with no background task comes down to 63s with -j2 
when HT is on.  So for this compilation, hyperthreading makes the CPU 
perform like 1.36 uniprocessors (in some sense).  I'll have to try to 
remember how to make -j2 the default...

Anyway, can I take it that the previous patches to improve this 
behaviour have never been merged?


Regards,  Phil.




