Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbXFGJuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbXFGJuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXFGJuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:50:16 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4143 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXFGJuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:50:15 -0400
Message-ID: <4667D4BC.2020806@shadowen.org>
Date: Thu, 07 Jun 2007 10:49:48 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie> <464B9573.8030407@zytor.com> <Pine.LNX.4.64.0705171013560.27336@skynet.skynet.ie> <465CAA86.5020402@shadowen.org> <465FEBD3.7020801@shadowen.org> <4660A7E0.6070600@zytor.com> <4665AD8B.80506@shadowen.org> <4665EA4F.2090004@zytor.com>
In-Reply-To: <4665EA4F.2090004@zytor.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andy Whitcroft wrote:
>>> It definitely sounds like a memory clobber of some sort.
>>>
>>> Usual suspects, in addition to the input/output buffers you already
>>> looked at, would be the heap and the stack.  Finding where the stack
>>> pointer lives would be my first, instinctive guess.
>> The stack seems to be where it should be and seems to stay pretty much
>> in the same place as it should.  Adding checks for the heap also seem to
>> stay within bounds.  I've tried making the stack and the heap 64k to no
>> effect.
>>
>> Moving the kernel to other places in memory seems to kill the decode
>> completely during gunzip() which may be a hint I am not sure.
>>
>> This thing is trying to ruin my mind.
>>
> 
> Yours and mine both.  Seems like *something* is clobbering memory, but
> what and why is a mystery.  The fact that putting the kernel in a higher
> point in memory is a good indication that this clobber is at a
> relatively high address.
> 
> How much RAM does this machine have?

This is as 12GB machine.  3 numa nodes.

I checked out the location of the IDT and GDT and both seem sane, in the
9xxxx range below the kernel destination.

I also note that on another machine of this type, one Node only in that
case some of the "did work" cases do not work.  Also when I applied some
of my patches on the top "working" cases stopped working.  So whatever
it is is definatly related to the shape of the kernel to be loaded.
Very confusing.

-apw
