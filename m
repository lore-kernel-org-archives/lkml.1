Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbYBKTsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbYBKTsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbYBKTs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:48:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756557AbYBKTs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:48:28 -0500
Date: Mon, 11 Feb 2008 11:38:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup
 and is unkillable [still broken in 2.6.25-rc1]
In-Reply-To: <200802112009.31018.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802111131310.2920@woody.linux-foundation.org>
References: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com> <200802112009.31018.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Feb 2008, Rafael J. Wysocki wrote:

> On Monday, 11 of February 2008, Alessandro Suardi wrote:
> > >
> > > 2.6.24-git1 is okay
> > > 2.6.24-git2 is bad

Ok, that's git ID's

	b47711bfbcd4eb77ca61ef0162487b20e023ae55 2.6.24-git1
	9b73e76f3cf63379dcf45fcd4f112f5812418d0a 2.6.24-git2

so if you get a git tree, you can do

	gitk b47711b..9b73e76

to see what happened in there. 

However, the obvious candidates are the scheduler or the ocfs2 merge, and 
the latter is only relevant in case you use ocfs2, of course. 

The rest of it tends to be the DVB and SCSI updates.

But it would be great if you could do a bisect and verify. Just do

	git bisect start
	git bisect good b47711bfbcd4eb77ca61ef0162487b20e023ae55
	git bisect bad 9b73e76f3cf63379dcf45fcd4f112f5812418d0a

and off you go..

		Linus
