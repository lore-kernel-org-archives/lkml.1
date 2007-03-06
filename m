Return-Path: <linux-kernel-owner+w=401wt.eu-S965764AbXCFC06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965764AbXCFC06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965768AbXCFC06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:26:58 -0500
Received: from terminus.zytor.com ([192.83.249.54]:60382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965764AbXCFC05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:26:57 -0500
Message-ID: <45ECD122.6020907@zytor.com>
Date: Mon, 05 Mar 2007 18:25:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch v2] epoll use a single inode ...
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org> <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Since this is not actually *used* for anything but showing the fd's in 
> /proc/<pid>/fd/ etc, no. In fact, an integer will wrap a *lot* less than a 
> kernel data structure will be re-used, so even with the simple "wraps 
> every 4G uses", you're still better off.
> 

... and if that worries you, use a 64-bit counter.  They're cheap 
(compared to an sprintf), and even if they advance once a nanosecond 
they won't wrap around for over 584 years.

> IOW, if the thing actually _mattered_ we should use some bitmap allocator 
> or similar (eg pidmaps etc), but with something where the only reason 
> really is as a visible indicator of difference for a user that happens to 
> look, simple-and-stupid is better.

That only makes sense if it matters that the numbers are kept small. 
This is in fact a highly suboptimal constraint, as it is almost 
guaranteed to create wraparounds much sooner, but there are situations 
in which that's the only option, e.g. for pty number allocations due to 
glibc braindamage.

	-hpa
