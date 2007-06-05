Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbXFEW6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbXFEW6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764975AbXFEW6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:58:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764864AbXFEW6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:58:03 -0400
Message-ID: <4665EA4F.2090004@zytor.com>
Date: Tue, 05 Jun 2007 15:57:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie> <464B9573.8030407@zytor.com> <Pine.LNX.4.64.0705171013560.27336@skynet.skynet.ie> <465CAA86.5020402@shadowen.org> <465FEBD3.7020801@shadowen.org> <4660A7E0.6070600@zytor.com> <4665AD8B.80506@shadowen.org>
In-Reply-To: <4665AD8B.80506@shadowen.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
>>>
>> It definitely sounds like a memory clobber of some sort.
>>
>> Usual suspects, in addition to the input/output buffers you already
>> looked at, would be the heap and the stack.  Finding where the stack
>> pointer lives would be my first, instinctive guess.
> 
> The stack seems to be where it should be and seems to stay pretty much
> in the same place as it should.  Adding checks for the heap also seem to
> stay within bounds.  I've tried making the stack and the heap 64k to no
> effect.
> 
> Moving the kernel to other places in memory seems to kill the decode
> completely during gunzip() which may be a hint I am not sure.
> 
> This thing is trying to ruin my mind.
> 

Yours and mine both.  Seems like *something* is clobbering memory, but
what and why is a mystery.  The fact that putting the kernel in a higher
point in memory is a good indication that this clobber is at a
relatively high address.

How much RAM does this machine have?

	-hpa
