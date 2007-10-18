Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbXJRWoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbXJRWoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbXJRWoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:44:22 -0400
Received: from smtp.petamem.com ([77.37.2.35]:46717 "EHLO smtp.petamem.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbXJRWoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:44:22 -0400
X-Greylist: delayed 2084 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 18:44:22 EDT
Date: Fri, 19 Oct 2007 00:05:10 +0200
From: Richard Jelinek <rj@petamem.com>
To: linux-kernel@vger.kernel.org
Subject: kswapd0 inefficient?
Message-ID: <20071018220510.GA22288@petamem.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys,

I'm not subscribed to this list, so if you find this question valid
enough to answer it, please cc me. Thanks.

This is what the top-output looks like on my machine after having
copied about 550GB of data from a twofish256 crypted disk to a raid
array:
--------------
Mem:   8178452k total,  8132180k used,    46272k free,  2743480k buffers
Swap:        0k total,        0k used,        0k free,  4563032k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 5954 root       0 -20     0    0    0 R   62  0.0  96:42.61 loop0
 6014 root      18   0 23744  19m  484 R   20  0.2  25:45.31 cp
  255 root      10  -5     0    0    0 S    8  0.0  10:21.82 kswapd0
 6011 root      10  -5     0    0    0 D    6  0.0   4:15.66 kjournald
...yadda yadda...
--------------

And what do we see here? We see loop0 and cp eating up some
time. That's ok for me considered the work they do. kjournald is also
ok for me, but I ask myself: why the heck has kswapd0 crunched 10+
minutes of CPU time?

I mean what does kswapd0 do?
http://www.linuxforums.org/forum/linux-kernel/65380-what-does-kswapd0-do.html

And I have no swap - right? So it should just shut up - IMHO. Or am I
missing something?


kind regards,
 Marcel
