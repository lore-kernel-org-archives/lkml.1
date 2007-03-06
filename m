Return-Path: <linux-kernel-owner+w=401wt.eu-S965263AbXCFQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263AbXCFQ27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965082AbXCFQ27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:28:59 -0500
Received: from terminus.zytor.com ([192.83.249.54]:55576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965263AbXCFQ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:28:58 -0500
Message-ID: <45ED96A6.3000704@zytor.com>
Date: Tue, 06 Mar 2007 08:28:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org> <45ECD122.6020907@zytor.com> <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com> <45ECD3D4.5020305@zytor.com> <Pine.LNX.4.64.0703051841380.4907@alien.or.mcafeemobile.com> <45ED08A9.9050501@cosmosbay.com>
In-Reply-To: <45ED08A9.9050501@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> 
> For epoll, I suspect this is harmless : Programs dont allocate epolls fd 
> every milli second, but at startup only.
> 
> For pipes/sockets, using a 64 bits would be problematic, because 
> sprintf() uses a divide for each digit. And a divide is slow. Ten 
> divides are *very* slow.
> 

That's true for *any* sprintf(), though.  sprintf() converts all its 
arguments to 64 bits.

However, this could be optimized.  I think right now sprintf() uses a 
generic divide-by-base, but a divide by 8 and 16 can of course be 
handled with a shift, and divide by 10 can be replaced with a 
multiplication by 0x1999999999999999ULL on most architectures.

	-hpa
