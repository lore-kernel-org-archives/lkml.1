Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbZHPX17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbZHPX17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 19:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZHPX16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 19:27:58 -0400
Received: from hole.yuiop.co.uk ([89.145.97.62]:38785 "EHLO hole.yuiop.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbZHPX15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 19:27:57 -0400
X-Greylist: delayed 1318 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Aug 2009 19:27:57 EDT
Message-ID: <4A8890B8.6070409@anonymous.org.uk>
Date: Mon, 17 Aug 2009 00:05:28 +0100
From: John Robinson <john.robinson@anonymous.org.uk>
Organization: None; Disorganization: Total
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.22) Gecko/20090605 Lightning/0.9 Thunderbird/2.0.0.22 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arjan van de Ven <arjan@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>, Mark Lord <liml@rtr.ca>,
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
References: <200908122007.43522.ngupta@vflare.org>	<20090813151312.GA13559@linux.intel.com>	<20090813162621.GB1915@phenom2.trippelsdorf.de>	<alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>	<87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>	<alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>	<3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>	<4A85E0DC.9040101@rtr.ca>	<f3177b9e0908141621j15ea96c0s26124d03fc2b0acf@mail.gmail.com>	<20090814234539.GE27148@parisc-linux.org>	<f3177b9e0908141719s658dc79eye92ab46558a97260@mail.gmail.com>	<1250341176.4159.2.camel@mulgrave.site>	<4A86B69C.7090001@rtr.ca>	<1250344518.4159.4.camel@mulgrave.site>	<20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>	<20090816083434.2ce69859@infradead.org> <20090816202905.59efa611@lxorguk.ukuu.org.uk>
In-Reply-To: <20090816202905.59efa611@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/2009 20:29, Alan Cox wrote:
>> trim is mostly for ssd's though, and those tend to not have the "goes
>> for a hike" behavior as much......
> 
> Bench one.
> 
>> I wonder if it's worse to batch stuff up, because then the trim itself
>> gets bigger and might take longer.....
> 
> They seem to implement a sort of async single threaded trim, which can
> only have one outstanding trim at a time.

I'm slightly out of my depth here, but: if a single TRIM is issued, 
which apparently returns quickly, can one then revert to issuing 
ordinary commands like reads and writes and have them complete as 
quickly as they normally do, or does any following command have to wait 
until the trim completes? This could be useful if it turned out we won't 
stall these devices as long as we don't issue more than one TRIM every 
few seconds; we could keep a TRIM coalesce queue down to being (say) 5 
seconds long (or at least, a configurable small number of seconds).

Cheers,

John.
