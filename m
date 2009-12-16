Return-Path: <linux-kernel-owner+w=401wt.eu-S935387AbZLPXTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387AbZLPXTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933850AbZLPXTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:19:53 -0500
Received: from khc.piap.pl ([195.187.100.11]:56043 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156AbZLPXTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:19:52 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Dave Airlie <airlied@linux.ie>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jean Delvare <jdelvare@suse.de>,
       Jeff Mahoney <jeffm@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fb/intelfb: Do not depend on EMBEDDED
References: <aa541tsbrtanvarunansa3uh.1260654940760@email.android.com>
	<200912131250.13797.jdelvare@suse.de>
	<alpine.DEB.2.00.0912132148550.24123@skynet.skynet.ie>
	<200912161437.32134.jdelvare@suse.de>
	<20091216100005.2c7e6d69@jbarnes-piketon>
	<m34onq1r4q.fsf@intrepid.localdomain>
	<alpine.DEB.2.00.0912162255501.25055@skynet.skynet.ie>
Date: Thu, 17 Dec 2009 00:19:49 +0100
In-Reply-To: <alpine.DEB.2.00.0912162255501.25055@skynet.skynet.ie> (Dave
	Airlie's message of "Wed, 16 Dec 2009 22:57:29 +0000 (GMT)")
Message-ID: <m3vdg6zeui.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@linux.ie> writes:

> Currently with the command line video=, this isn't optimal but still
> nobody has come up with a way to make fbset useful since it can't deal
> with multiple heads.

Ahh, now I can see it.

> also the old intelfb didn't deal with analog rgb tv at all.

Well... actually, it did: intelfb works very well if a correct mode is
set (a trivial patch adjusting the clock lower limit to 13.5 MHz may be
needed, or one can use the double clock and resolution, or maybe 1:1
pixel aspect ratio etc). It's not about the CH7xxx encoder, the TV is
connected directly to VGA output.

E.g.

# PAL 720x576, 50 Hz, Interlaced (13.5 MHz dotclock)
#
#                               Horizontal      Vertical
#       Resolution              720             576
#       Scan Frequency          15.625 kHz      50 Hz (I)
#       Sync Width              4.296 us        1.280 ms
#       Front Porch             1.000 us        0.256 ms
#       Back Porch              5.370 us        1.600 ms
#       Active Time             53.333 us       36.864 ms
#       Blank Time              10.667 us       3.136 ms
#       Polarity                Negative        Negative
#
#       H:      720 + 14 +  58 + 72 = 864
#       V:      576 +  4 +  20 + 25 = 625

mode "PAL"
        # D: 13.5 MHz, H: 15.625 kHz, V: 50 Hz
        geometry 720 576 720 576 32
        timings 74074 72 14 25 4 58 20
        laced true
        hsync low
        vsync low
endmode

"fbset PAL" is all one needs to use it.

(I know i915 doesn't have interlaced mode support for analog VGA out,
not a problem).
-- 
Krzysztof Halasa
