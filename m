Return-Path: <linux-kernel-owner+w=401wt.eu-S1764406AbXESVwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764406AbXESVwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 17:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbXESVwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 17:52:39 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:34015 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbXESVwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 17:52:38 -0400
Subject: Re: [RFC] LZO1X de/compression support
From: Richard Purdie <richard@openedhand.com>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Nitin Gupta <nitingupta910@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070519185514.GA17869@ti88.telemetry-investments.com>
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
	 <m3646pg7fy.fsf@maximus.localdomain>
	 <20070519185514.GA17869@ti88.telemetry-investments.com>
Content-Type: text/plain
Date: Sat, 19 May 2007 22:52:12 +0100
Message-Id: <1179611532.5852.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 14:55 -0400, Bill Rugolsky Jr. wrote:
> On Fri, May 18, 2007 at 11:14:57PM +0200, Krzysztof Halasa wrote:
> > I'm certainly missing something but what are the advantages of this
> > code (over current gzip etc.), and what will be using it?
> 
> Richard's patchset added it to the crypto library and wired it into
> the JFFS2 file system. 

Basically, LZO has much faster decompression speeds. For jffs2, there
was a 40% filesystem read speed improvement with LZO compared to zlib
and that resulted in a device booting 10% faster. The drawback was a
slight drop in file compression (say 5% although it varied a lot
depending on the test data). For lots of uses, that is an acceptable
compromise.

It appears resier4 is using LZO too.

> We recently started using LZO in a userland UDP
> proxy to do stateless per-packet payload compression over a WAN link.
> With ~1000 octet packets, our particular data stream sees 60% compression
> with zlib, and 50% compression with (mini-)LZO, but LZO runs at ~5.6x
> the speed of zlib.  IIRC, that translates into > 700Mbps on the input
> side on a 2GHZ Opteron, without any further tuning.

Those figures sound comparable with my experiences...

Richard


