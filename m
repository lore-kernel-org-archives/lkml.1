Return-Path: <linux-kernel-owner+w=401wt.eu-S1161252AbXCGDrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161252AbXCGDrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161253AbXCGDrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:47:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46094 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161252AbXCGDrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:47:55 -0500
Date: Tue, 6 Mar 2007 19:47:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <45EDCD11.8070000@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703061944590.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org>
 <200703061828.00253.dada1@cosmosbay.com> <200703061910.13431.dada1@cosmosbay.com>
 <45EDCD11.8070000@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, Eric Dumazet wrote:
> 
> I did a user space program, attached to this mail.
> 
> I rewrote the reciprocal_div() for i386 so that one multiply is used.

Ok, this is definitely faster on Core 2 as well, so "numbers talk, 
bullshit walks". No more objections.

(That said, I bet you could do even better for octal and hex numbers, so 
if you *really* want to speed things up, you should just make a 
special-case routine for each base (there's just three of them), and you 
can then also optimize the base-10 thing much better (you can do two 
digits at a time by dividing by 100, etc)

		Linus
