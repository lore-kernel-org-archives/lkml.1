Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbZHPOQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbZHPOQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 10:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZHPOQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 10:16:03 -0400
Received: from rtr.ca ([76.10.145.34]:38720 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbZHPOQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 10:16:01 -0400
Message-ID: <4A8814A0.4040708@rtr.ca>
Date: Sun, 16 Aug 2009 10:16:00 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Chris Worley <worleys@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Bryan Donlan <bdonlan@gmail.com>, david@lang.hm,
       Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 slot is freed)
References: <200908122007.43522.ngupta@vflare.org>	<20090813151312.GA13559@linux.intel.com>	<20090813162621.GB1915@phenom2.trippelsdorf.de>	<alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>	<87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>	<alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>	<3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>	<4A85E0DC.9040101@rtr.ca>	<f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>	<20090814234539.GE27148@parisc-linux.org>	<f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>	<1250341176.4159.2.camel@mulgrave.site>	<4A86B69C.7090001@rtr.ca>	<1250344518.4159.4.camel@mulgrave.site> <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>
In-Reply-To: <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>
> Flush barriers are nightmare for more than enterprise. You drive
> basically goes for a hike for a bit which trashes interactivity as well.
> If the device can't do trim and the like without a drain I don't see much
> point doing it at all, except maybe to wait for idle devices and run a
> filesystem managed background 'strimmer' thread to just weed out now idle
> blocks that have stayed idle - eg by adding an inode of all the deleted
> untrimmed blocks and giving it an irregular empty ?
..

Agreed.  And I believe Matthew also said something similar already.
TRIM for the current (only!) SSDs needs to be a "batched, once in a while"
operation, rather than something done continuously.

And ideally, "once in a while" might be once a day, or once we have more
than a significant percentage of the drive capacity ready for a TRIM.

It needs to batch a lot of stuff into a single TRIM,
and not do it very often at all.

Cheers
