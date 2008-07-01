Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYGAMIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYGAMIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYGAMI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:08:26 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:60049 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYGAMIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:08:25 -0400
Message-ID: <486A1E04.3010600@skyrush.com>
Date: Tue, 01 Jul 2008 06:07:32 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: Elias Oltmanns <eo@nebensachen.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local> <87abh2rpzg.fsf@denkblock.local> <4869EABD.1090009@gmail.com>
In-Reply-To: <4869EABD.1090009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin wrote:
> Thanks for the patch , the process seems to respond faster to Ctrl-C,
> but I'll have to find a way to measure that reliably.
> However ^C is not echoed anymore for me.

I found the same thing when I originally did the ^C echo patch.  If isig() was
used instead of the order specified (flush, echo, signal), the ^C did not echo
reliably (i.e., it echoed on a tty console, but not in an xterm).  isig() does
the kill, then the flush.

Note that ^Z uses the same logic, so the fact that you are seeing this take
effect more quickly is interesting.

I will try a few things today, but please experiment with various orderings of
the calls and let me know what you find (and test the ^C echo in both tty
console and xterm).

						-Joe
