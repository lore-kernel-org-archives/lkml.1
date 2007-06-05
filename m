Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbXFESiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbXFESiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbXFESiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:38:09 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2047 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbXFESiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:38:08 -0400
Message-ID: <4665AD8B.80506@shadowen.org>
Date: Tue, 05 Jun 2007 19:38:03 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie> <464B9573.8030407@zytor.com> <Pine.LNX.4.64.0705171013560.27336@skynet.skynet.ie> <465CAA86.5020402@shadowen.org> <465FEBD3.7020801@shadowen.org> <4660A7E0.6070600@zytor.com>
In-Reply-To: <4660A7E0.6070600@zytor.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Andy Whitcroft wrote:
>> I think that my debugging says that newsetup got the compressed kernel
>> and decompressor into memory ok and execution passed to it normally.
>> But I cannot figure out where the corruption is coming from.  I tried
>> annotating the gzip decompressor to see if the input and output buffers
>> were overlapping at any time and that debug said no (unsure how reliable
>> that is).  And yet at some point the output image is munched up.
>>
>> One last piece of information.  The decompressor also always seems to
>> get to the end of the input stream in exactly the right place without
>> reporting any kind of error, that is with exactly 8 bytes left over for
>> the length and crc checks.  Which given the context sensitive nature of
>> the algorithm tends to imply the input stream was ok for the whole
>> duration of the decompress.  Yet the output stream is badly broken.
>>
>> Anyone got any wacky suggestions ...
>>
> 
> It definitely sounds like a memory clobber of some sort.
> 
> Usual suspects, in addition to the input/output buffers you already
> looked at, would be the heap and the stack.  Finding where the stack
> pointer lives would be my first, instinctive guess.

The stack seems to be where it should be and seems to stay pretty much
in the same place as it should.  Adding checks for the heap also seem to
stay within bounds.  I've tried making the stack and the heap 64k to no
effect.

Moving the kernel to other places in memory seems to kill the decode
completely during gunzip() which may be a hint I am not sure.

This thing is trying to ruin my mind.

-apw
