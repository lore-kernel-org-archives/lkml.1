Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbXJ3SOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbXJ3SOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXJ3SOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:14:31 -0400
Received: from sandeen.net ([209.173.210.139]:27364 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbXJ3SOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:14:30 -0400
Message-ID: <47277485.5090500@sandeen.net>
Date: Tue, 30 Oct 2007 13:14:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       byron.bbradley@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: XFS Fails Quality Assurance Tests on ARM
References: <fb80ve$i5q$1@sea.gmane.org> <20070830.213901.48806818.davem@davemloft.net> <p73ps12vxrl.fsf@bingen.suse.de> <4726C577.9000209@sandeen.net> <20071030175418.GA17768@infradead.org>
In-Reply-To: <20071030175418.GA17768@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Oct 30, 2007 at 12:47:35AM -0500, Eric Sandeen wrote:
>> There was a patch floating around to "fix" it but it's not on-disk
>> compatible w/ x86 & friends, it just makes things consistent for arm.  I
>> think packing some of these structures would take care of it, but this
>> problem could use some attention & testing I think, it's been floating
>> around a long time.
> 
> Do you have a pointer to that patch?  Once the unaliged fields are
> identified simply using get_unaligned on them should fix this issue.
> 

http://www.spinics.net/lists/arm-kernel/msg18479.html

is the one I was thinking of, IIRC, but it just does the math a
different way so that it comes out right on ARM, and doesn't fix the
underlying problem.  I think the end result is no crashes, but a
filesystem which is broken when used on another arch.

But the problem AFAIK is that the *on-disk* structures don't match when
compiled with one ARM abi or another, I think, so get_unaligned isn't
going to help here.

-Eric
