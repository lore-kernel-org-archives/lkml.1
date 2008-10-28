Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbYJ1Brm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbYJ1Brm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbYJ1Brd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:47:33 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:56799 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYJ1Brc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:47:32 -0400
From: James Cloos <cloos@jhcloos.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, khc@pm.waw.pl,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: radeonfb lockup in .28-rc (bisected)
In-Reply-To: <20081027.170008.112856238.davem@davemloft.net> (David Miller's
	message of "Mon, 27 Oct 2008 17:00:08 -0700 (PDT)")
References: <m31vy1k3ea.fsf@lugabout.jhcloos.org>
	<20081027.170008.112856238.davem@davemloft.net>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2008 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 27 Oct 2008 21:46:52 -0400
Message-ID: <m3vdvdij8c.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:23:081028:davem@davemloft.net::o0bFYwEUmFIbAfhM:0000000000000000000000000000000000000000006TFe
X-Hashcash: 1:23:081028:linux-kernel@vger.kernel.org::FPsfhrwb2iYE93n/:0000000000000000000000000000000007TnK
X-Hashcash: 1:23:081028:benh@kernel.crashing.org::33Uwj9i+Xrc/6tTj:0000000000000000000000000000000000000Ix14
X-Hashcash: 1:23:081028:torvalds@linux-foundation.org::9u+C/R6n8khJi5ja:000000000000000000000000000000002Gnu
X-Hashcash: 1:23:081028:akpm@linux-foundation.org::5tvXs2/AU/T/u4Rx:000000000000000000000000000000000000H8lW
X-Hashcash: 1:23:081028:khc@pm.waw.pl::xTSmluOZc79JAexN:0000081W
X-Hashcash: 1:23:081028:linux-fbdev-devel@lists.sourceforge.net::u7iSokehjE7n4bvK:00000000000000000000006Oc/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "David" == David Miller <davem@davemloft.net> writes:

David> Please quote at least the headerline of the commit so that it can
David> come into our memory quickly when reading your report.

Good point.

David> The actual key here is that when setfont runs, the framebuffer
David> layer sets the acceleration options for the framebuffer for the
David> first time to their final settings.

Explains why it breaks.  Thanks!

>> -Memory: 512232k/524200k available (4376k kernel code, 11428k reserved, 1707k data, 320k init, 0k highmem)
>> +Memory: 512272k/524200k available (4354k kernel code, 11388k reserved, 1693k data, 316k init, 0k highmem)

David> That's just all due to the text size change because of the
David> different acceleration code.

I left a bit too much unsaid there, but that was the point I was
making.  Ie, nothing of issue.

Incidently, it only took 14 hours of compiling to accomplish the
bisect.  And that was after a s/=m$/=n/. on my .27 .config.

Anyone bisecting should know that the new HID code is not bisect-safe.
The dell, lg, bright and sony hid drivers all are auto Y if hid is Y and
embedded is N and fail to link (when bisecting) due to missing symbols.

-JimC (still waking up)
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
