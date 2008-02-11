Return-Path: <linux-kernel-owner+w=401wt.eu-S1760752AbYBKT6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752AbYBKT6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760266AbYBKT6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:58:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbYBKT6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:58:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-git2: Oracle 11g VKTM process enters R state on startup and is unkillable [still broken in 2.6.25-rc1]
Date: Mon, 11 Feb 2008 20:56:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <5a4c581d0802110820l1fcbb1ffib874f268b4ab7eae@mail.gmail.com> <200802112009.31018.rjw@sisk.pl> <alpine.LFD.1.00.0802111131310.2920@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802111131310.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802112056.17839.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 of February 2008, Linus Torvalds wrote:
> 
> On Mon, 11 Feb 2008, Rafael J. Wysocki wrote:
> 
> > On Monday, 11 of February 2008, Alessandro Suardi wrote:
> > > >
> > > > 2.6.24-git1 is okay
> > > > 2.6.24-git2 is bad
> 
> Ok, that's git ID's
> 
> 	b47711bfbcd4eb77ca61ef0162487b20e023ae55 2.6.24-git1
> 	9b73e76f3cf63379dcf45fcd4f112f5812418d0a 2.6.24-git2
> 
> so if you get a git tree, you can do
> 
> 	gitk b47711b..9b73e76
> 
> to see what happened in there. 
> 
> However, the obvious candidates are the scheduler or the ocfs2 merge, and 
> the latter is only relevant in case you use ocfs2, of course. 
> 
> The rest of it tends to be the DVB and SCSI updates.
> 
> But it would be great if you could do a bisect and verify. Just do
> 
> 	git bisect start
> 	git bisect good b47711bfbcd4eb77ca61ef0162487b20e023ae55
> 	git bisect bad 9b73e76f3cf63379dcf45fcd4f112f5812418d0a
> 
> and off you go..

Well, I've already bisected that down to commit
6f505b16425a51270058e4a93441fe64de3dd435 "sched: rt group scheduling" and
provided a simple test case.  Moreover, there are patches from Peter that fix
the problem, but they are lost somewhere in the way from him to you (please see
http://lkml.org/lkml/2008/2/5/535 and http://lkml.org/lkml/2008/2/6/320).

Thanks,
Rafael
