Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812Ab0AISbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0AISbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 13:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711Ab0AISbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 13:31:22 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:38615 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0AISbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 13:31:21 -0500
X-Greylist: delayed 1150 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jan 2010 13:31:21 EST
To: linux-kernel@vger.kernel.org
Subject: Leaky Bucket qdisc
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8bit
From: Mattias =?utf-8?Q?R=C3=B6nnblom?= <hofors@lysator.liu.se>
Date: Sat, 09 Jan 2010 19:12:10 +0100
Message-ID: <87d41jrvut.fsf@isengard.friendlyfire.se>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

to learn a little something about the kernel and to be able to do some
benchmarks on the HR timers I wrote a leaky bucket traffic shaping
qdisc.

For those who don't know, leaky bucket requires (very) high resolution
timers, and is more strict than TBF in that it doesn't allow a burst
(other than a single frame will go out at a line speed, of course).

However, my understanding from the TBF qdisc documentation is that you
can achieve the same effect with TBF, even to the point of not
allowing any bursts, which makes LB pretty much redundant. I thought I
would send this e-mail anyway, to see if there was some interest in
this little piece of code. If so, I'll try to clean it up and submit
it.

One benefit with LB is that it's very easy to configure. There's only
one parameter: the configured rate. It's non-work conserving and my
implementation is classless, with an inner qdisc, just like TBF. I've
patched 'tc' too to cope with LB.

It requires HR timers, and the better timers, the closer to the
configured rate you'll get. My system's timer resolution allows me to
shape with up to about 100 Mbit/s, if I recall correctly.

Best regards,
     Mattias
