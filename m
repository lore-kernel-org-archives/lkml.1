Return-Path: <linux-kernel-owner+w=401wt.eu-S965533AbXCFSKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbXCFSKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965538AbXCFSKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:10:15 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:41899 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965520AbXCFSKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:10:12 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 10:10:05 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <45ED96A6.3000704@zytor.com>
Message-ID: <Pine.LNX.4.64.0703061008570.12892@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org>
 <45ECD122.6020907@zytor.com> <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com>
 <45ECD3D4.5020305@zytor.com> <Pine.LNX.4.64.0703051841380.4907@alien.or.mcafeemobile.com>
 <45ED08A9.9050501@cosmosbay.com> <45ED96A6.3000704@zytor.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, H. Peter Anvin wrote:

> Eric Dumazet wrote:
> > 
> > For epoll, I suspect this is harmless : Programs dont allocate epolls fd
> > every milli second, but at startup only.
> > 
> > For pipes/sockets, using a 64 bits would be problematic, because sprintf()
> > uses a divide for each digit. And a divide is slow. Ten divides are *very*
> > slow.
> > 
> 
> That's true for *any* sprintf(), though.  sprintf() converts all its arguments
> to 64 bits.

Sigh! We *always* do do_div(), even for the more trivial %x case.
Anyway, it does not really matter for the type of dfs will be applied to.


- Davide


