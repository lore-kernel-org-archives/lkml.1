Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbXEAQXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbXEAQXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbXEAQXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:23:06 -0400
Received: from inetc.connecttech.com ([64.7.140.42]:2702 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbXEAQXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:23:05 -0400
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'Satyam Sharma'" <satyam.sharma@gmail.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Christoph Hellwig'" <hch@infradead.org>,
       "'Roland McGrath'" <roland@redhat.com>,
       "'Christoph Hellwig'" <hch@lst.de>, <linux-kernel@vger.kernel.org>,
       <linux-arch@vger.kernel.org>
Subject: RE: condingstyle, was Re: utrace comments
Date: Tue, 1 May 2007 12:15:00 -0400
Organization: Connect Tech Inc.
Message-ID: <001601c78c0b$deb12a30$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <a781481a0704301142sfec317cu8213750c9ab84416@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: On Behalf Of Satyam Sharma
> readable and obvious at first glance itself. For example, consider:
               ^^^^^^^^^^^^^^^^^^^^^^^
> 
> 	if (veryverylengthycondition1 &&
> 		smallcond2 &&
> 		(conditionnumber3a ||
> 		condition3b)) {
> 		...
> 	}
> 
> versus

Whoops! You've got an unterminated if there, let me fix it up...

> 	if (veryverylengthycondition1) {
> 	    && smallcond2
> 	    && (conditionnumber3a
> 	        || condition3b)) {
> 		...
> 	}> 

From: On Behalf Of Scott Preece
> I still find the leading-operator style much more readable. The most
> important thing in reading a long, complex conditional is
> understanding the structure of the operators, not the operands.

Since there's a mix of pre-, post- and infix, the structure of the
operators _depends on_ the operands.

> However, there's a lot of difference of opinion on this (perhaps
> rooted in differences in cognition and reading behavior). For me it's
> not even close - expressions broken so the operators are at the head
> of the line snap into focus and those with operators at the ends of
> the lines look like undifferentiated goo. Since some of the style

I'm exactly opposite; the "uncorrected" line above is a typo because
there's no continuation item at the end of the line. I don't even see
the following lines because they are, by definition, not part of the
code I'm looking at. Leaving the operators at the end of the line I
easily see that it's a binary operator, and there's no second operand
so the next line must contain it, parse the next line as well.

Hm. I didn't realise this but the unspoken underlying factor for me is
the "one instruction per line" style. If you must break over multiple
lines, there must be a continuation item to indicate that. This is how
I detect missing semicolons.

..Stu

