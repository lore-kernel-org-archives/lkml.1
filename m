Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXBEUmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXBEUmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933440AbXBEUmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:42:47 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60809 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439AbXBEUmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:42:45 -0500
Date: Mon, 5 Feb 2007 12:42:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <22734C32-BC8C-49E8-B6EB-E150B916323E@oracle.com>
Message-ID: <Pine.LNX.4.64.0702051239310.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org>
 <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
 <20070203082308.GA6748@elte.hu> <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com>
 <22734C32-BC8C-49E8-B6EB-E150B916323E@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, Zach Brown wrote:
> 
> For syscalls, sure.
> 
> The kevent work incorporates Uli's desire to have more data per event.  Have
> you read his OLS stuff?  It's been a while since I did so I've lost the
> details of why he cares to have more.

You'd still do that as _arguments_ to the system call, not as the return 
value.

Also, quite frankly, I tend to find Uli over-designs things. The whole 
disease of "make things general" is a CS disease that some people take to 
extreme.

The good thing about generic code is not that it solves some generic 
problem. The good thing about generics is that they mean that you can 
_avoid_ solving other problems AND HAVE LESS CODE. But some people seem to 
think that "generic" means that you have to have tons of code to handle 
all the possible cases, and that *completely* misses the point.

We want less code. The whole (and really, the _only_) point of the 
fibrils, at least as far as I'm concerned, is to *not* have special code 
for aio_read/write/whatever.

		Linus
