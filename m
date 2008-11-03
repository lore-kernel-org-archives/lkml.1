Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYKCPeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYKCPeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbYKCPeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:34:13 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:51231 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbYKCPeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:34:12 -0500
From: James Cloos <cloos@jhcloos.com>
To: benh@kernel.crashing.org
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [Linux-fbdev-devel] radeonfb lockup in .28-rc (bisected)
In-Reply-To: <1225662539.8004.237.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Mon, 03 Nov 2008 08:48:59 +1100")
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	<1225152347.8004.49.camel@pasglop>
	<m3k5bt2hsc.fsf@lugabout.jhcloos.org>
	<1225662539.8004.237.camel@pasglop>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2008 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 03 Nov 2008 10:33:04 -0500
Message-ID: <m33ai8akoo.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:23:081103:benh@kernel.crashing.org::kDfaErG1vcAL+7e4:00000000000000000000000000000000000008dz4
X-Hashcash: 1:23:081103:linux-fbdev-devel@lists.sourceforge.net::U/53PaQpUezbvnal:0000000000000000000000OsUr
X-Hashcash: 1:23:081103:linux-kernel@vger.kernel.org::Hiyr3eEsda0qp5Uk:000000000000000000000000000000002fmZh
X-Hashcash: 1:23:081103:akpm@linux-foundation.org::hBQ/kh2436smhZ6n:0000000000000000000000000000000000003ULX
X-Hashcash: 1:23:081103:torvalds@linux-foundation.org::L2lib4NuMLo0PW9Y:00000000000000000000000000000000I3Eq
X-Hashcash: 1:23:081103:davem@davemloft.net::3MjCZ1f0aixerLkC:0000000000000000000000000000000000000000000MbH
X-Hashcash: 1:23:081103:khc@pm.waw.pl::CbTq0qtY35pd7r2G:0000L8p5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Benjamin" == Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>> is in play.  It is probably spinning through all of the 2000000 possible
>> udelay(10) calls.  I don't think I ever gave it twenty seconds before
>> giving up.  And certainly not forty seconds, if the freeze happens after
>> setting the DST_Y_X register.

Benjamin> Well, setting DST_Y_X is what triggers the transfer. The above
Benjamin> means that the FIFO isn't emptying (ie, the engine is locked up).

I gave it another try over the weekend and let it sit for five minutes.
The reset message never appeared.

Benjamin>  - We can blacklist that chip for imageblit (it's not a huge
Benjamin> improvement on x86 anyway).

No objections here.

Benjamin>  - We can be smart, reduce the timeout above, and "detect" the
Benjamin> lockup, when it happens, reset the engine and disable the
Benjamin> acceleration that locked up.

Given Paul's report, that seems like the long term solution.

Benjamin> Now, the problem is ... My second son was just born last
Benjamin> wed. so I'm pretty unavailable right now.

Congrats!

Benjamin>  Thus, for .29, I'm tempted to go for the simpler approach
Benjamin> which is to blacklist M7's from imageblit acceleration.

Again, that is fine by me.  Otherwise I'll just leave the #if0 commit
in my compile clone.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
