Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbXEGT7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbXEGT7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbXEGT7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:59:04 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:55662
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbXEGT7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:59:03 -0400
Date: Mon, 7 May 2007 12:55:56 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Pavel Machek <pavel@ucw.cz>
cc: Oliver Neukum <oneukum@suse.de>,
       David Lang <david.lang@digitalinsight.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <20070507195142.GC3981@ucw.cz>
Message-ID: <Pine.LNX.4.64.0705071250460.21621@asgard.lang.hm>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
 <Pine.LNX.4.63.0705061909290.19118@qynat.qvtvafvgr.pbz> <20070507124818.GA18209@elf.ucw.cz>
 <200705071452.21969.oneukum@suse.de> <Pine.LNX.4.64.0705070736010.18013@asgard.lang.hm>
 <20070507195142.GC3981@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Pavel Machek wrote:

>>>> Really? It works today... if the suspend is short
>>>> enough. And that's
>>>> how it should be.
>>>
>>> If we get very good at Wake-on-Lan it should work for
>>> any length
>>> of time.
>>
>> for suspend-to-ram this would work, I stand corrected.
>>
>> for hibernate this would almost certinly not work, and I
>> don't think that it's worth raising false hopes.
>
> Check the facts. It used to work, and it should work today.

I don't dispute that it sometimes works today.

what I dispute is that makeing it work should be a contraint on a cleaner 
design that happens to cause tcp connections to fail on suspend-to-disk 
(hibernate).

if you are dong suspend-to-disk for such a short period that TCP 
connections are able to recover (typically <15 min for most firewalls, in 
some cases <2 min for connections with keep-alive) is it really worth it?

and once you pass the timeframes where the connections are still alive 
then it shouldn't matter, and in fact the server should gracefully close 
the connections to be nice to other devices and servers on the network.

I dispute the idea that doing a suspend-to-disk and expecting that your 
network connections will recover when you wake up is a sane expectation.

David Lang
