Return-Path: <linux-kernel-owner+w=401wt.eu-S933566AbXBXVZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566AbXBXVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 16:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933568AbXBXVZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 16:25:28 -0500
Received: from signal.itea.ntnu.no ([129.241.190.231]:59726 "EHLO
	signal.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566AbXBXVZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 16:25:28 -0500
X-Greylist: delayed 1853 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Feb 2007 16:25:27 EST
Message-ID: <20070224215403.ka5imjqjo08cko0c@webmail.ntnu.no>
Date: Sat, 24 Feb 2007 21:54:03 +0100
From: Sindre =?iso-8859-1?b?QWFt5XM=?= <aamas@stud.ntnu.no>
To: linux-kernel@vger.kernel.org
Subject: Correct way for an application to sleep?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
X-Content-Scanned: with sophos and spamassassin at mailgw.ntnu.no.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I realise that this is not a question strictly related to development  
of linux, but there have been changes related to sleep granularity  
lately, and I'm assuming these changes are made with an idea of how  
sleep functions are expected to be used from user space. Since some of  
these changes have made my situation worse (although the recent  
development wrt high-res timers and dynamic tick looks promising), I'd  
like to know if situations like mine are accounted for in the plans  
behind such changes, or if I'm just relying on the wrong things here,  
and how the kernel wants a user space app to behave wrt this.

I'm developing a game console emulator. This needs to be synced to the  
host's time at regular intervals, eg. 70224 emulated cycles pr  
~16.7427 ms. This should preferably happen once every frame, so that  
the next frame lasts as long as the previous, giving non-choppy  
display. At the same time I need to resample the emulated sound to the  
host's sample rate, and stream it to the sound card. This means that  
if I fail to consistently keep within these limits I will get choppy  
display, and fluctuating pitch (or buffer underruns depending on how I  
resample). One way to keep within these limits is to busy-wait, but  
that seems like a kind of obnoxious way for an application to behave,  
not to mention that it will drain an eventual battery (and probably  
cause global warming, kill kittens etc.). So, I would like to give  
away as much cpu time as possible keeping within these limits.

If I have access to waitForVblank()-like functions I could supposedly  
resample the emulated video to the host's frame rate and use this.  
Unfortunately I often don't have that possibility, besides resampling  
frame rate in real time can be very resource intensive (and give  
motion blurry visuals).

Afaik, if I were to sync by means of sound hardware needing more  
samples, I wouldn't be able keep a consistent frame rate. Unless I can  
set a weird buffer size, use a static resampling ratio, and  
approximate the emulated system's speed slightly. If there are more  
sophisticated ways to sync through sound hardware, that may be a  
complete solution (for my specific case).

Without root-privilegies, that leaves general purpose sleep functions  
like nanosleep afaik. The problem is that the granularity of these  
seems very unpredictable, and if I am to use a lowest common  
denominator I'd only be able to sleep like 10 ms pr 16.7 ms on fast  
systems, and not at all on not so fast systems. So, I'd like to know  
what the "correct" way to handle this kind of situation is, if any,  
from a kernel perspective. Is the only sensible thing to do to give a  
user settable preference, deciding on a compromise default (or one  
that says "screw you old kernels")?

Please keep me CC'd if you reply to this thread.

Thanks.

