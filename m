Return-Path: <linux-kernel-owner+w=401wt.eu-S964783AbXBEWfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783AbXBEWfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965012AbXBEWfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:35:11 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4134 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964783AbXBEWfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:35:10 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Feb 2007 14:34:48 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: bert hubert <bert.hubert@netherlabs.nl>, Ingo Molnar <mingo@elte.hu>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <Pine.LNX.4.64.0702051350010.8424@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702051432330.14453@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
 <20070205213618.GA30923@outpost.ds9a.nl> <Pine.LNX.4.64.0702051350010.8424@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Linus Torvalds wrote:

> On Mon, 5 Feb 2007, bert hubert wrote:
> > 
> > From my end as an application developer, yes please. Either make it
> > perfectly ok to have thousands of outstanding asynchronous system calls (I
> > work with thousands of separate sockets), or allow me to select/poll/epoll
> > on the "async fd".
> 
> No can do.
> 
> Allocating an fd is actually too expensive, exactly because a lot of these 
> operations are supposed to be a few hundred ns, and taking locks is simply 
> a bad idea.
> 
> But if you want to, we could have a *separate* "convert async cookie to 
> fd" so that you can poll for it, or something.
> 
> I doubt very many people want to do that. It would tend to simply be nicer 
> to do
> 
> 	async(poll);
> 	async(waitpid);
> 	async(.. wait foranything else ..)
> 
> followed by a
> 
> 	wait_for_async();
> 
> That's just a much NICER approach, I would argue. And it automatically 
> and very naturally solves the "wait for different kinds of events" 
> question, in a way that "poll()" never did (except by turning all events 
> into file descriptors or signals).

Bert, that was the first suggestion I gave to Zab. But then I realized 
that a multiplexed poll/epoll can be "hosted" in an async op, just like 
Linus showed above. Will work just fine IMO.




- Davide


