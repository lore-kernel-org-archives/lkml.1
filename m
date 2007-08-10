Return-Path: <linux-kernel-owner+w=401wt.eu-S965304AbXHJVJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965304AbXHJVJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759087AbXHJVI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:08:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42953 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbXHJVI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:08:56 -0400
Message-ID: <46BCD3E7.1050403@garzik.org>
Date: Fri, 10 Aug 2007 17:08:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: netdev@vger.kernel.org, davem@davemloft.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Driver writer hints (was [PATCH 3/4] Add ETHTOOL_[GS]PFLAGS	sub-ioctls)
References: <20070810202426.GA25050@havoc.gtf.org>	<20070810202630.GB25095@havoc.gtf.org> <46BCCE57.1060802@garzik.org> <46BCD223.6020304@hp.com>
In-Reply-To: <46BCD223.6020304@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rick Jones wrote:
>> If we are getting (retrieving) flags:
>>
>>     3) Userland issues ETHTOOL_GPFLAGS, to obtain a 32-bit bitmap
>>
>>     4) Userland prints out a tag returned from ETHTOOL_GSTRINGS
>>        for each bit set to one in the bitmap.  If a bit is set,
>>        but there is no string to describe it, that bit is ignored.
>>        (i.e. a list of 5 strings is returned, but bit 24 is set)
> 
> Is that to enable "hidden" bits?  If not I'd think that emitting some 
> sort of "UNKNOWN_FLAG" might help flush-out little oopses like 
> forgetting a string.

No purpose other than attempting to define sane edge case behavior.

The bitmap interface is completely invisible to the user (who sees UTF8 
strings on the command line), and given the interface I felt the easiest 
thing to do would be to define an "ignore any garbage" default policy.

Due to the way the interface is designed, each userland user must be 
aware of the precise number of valid bits in the bitmap /anyway/, thus 
making clipping/ignoring garbage bits almost a trivial side effect.

	Jeff



