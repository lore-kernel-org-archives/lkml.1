Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXBFV3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXBFV3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXBFV3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:29:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51853 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbXBFV3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:29:14 -0500
Date: Tue, 6 Feb 2007 13:28:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: kent.overstreet@gmail.com, davidel@xmailserver.org, zach.brown@oracle.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       suparna@in.ibm.com, bcrl@kvack.org
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070206.131631.82049180.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0702061325380.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
 <20070206.131631.82049180.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, David Miller wrote:
> 
> I really think that Evgeniy's kevent is a good event notification
> mechanism for anything, including AIO.
> 
> Events are events, applications want a centralized way to receive and
> process them.

Don't be silly. AIO isn't an event. AIO is an *action*.

The event part is hopefully something that doesn't even *happen*.

Why do people ignore this? Look at a web server: I can pretty much 
guarantee that 99% of all filesystem accesses are cached, and doing them 
as "events" would be a total and utter waste of time.

You want to do them synchronously, as fast as possible, and you do NOT 
want to see them as any kind of asynchronous events.

Yeah, in 1% of all cases it will block, and you'll want to wait for them. 
Maybe the kevent queue works then, but if it needs any more setup than the 
nonblocking case, that's a big no.

		Linus
