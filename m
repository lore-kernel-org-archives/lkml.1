Return-Path: <linux-kernel-owner+w=401wt.eu-S933927AbXFFAho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbXFFAho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933081AbXFFAhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:37:36 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1579 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923AbXFFAhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:37:35 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 5 Jun 2007 17:37:33 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
 woes
In-Reply-To: <1181088936.2788.10.camel@entropy>
Message-ID: <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com>
References: <1181006711.31677.97.camel@localhost.localdomain> 
 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org> 
 <1181009413.31677.117.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com> 
 <1181013756.31677.123.camel@localhost.localdomain>  <1181023787.2785.14.camel@entropy>
  <1181028453.31677.127.camel@localhost.localdomain>  <1181087462.2788.8.camel@entropy>
  <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com>
 <1181088936.2788.10.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Nicholas Miell wrote:

> On Tue, 2007-06-05 at 17:11 -0700, Davide Libenzi wrote:
> > On Tue, 5 Jun 2007, Nicholas Miell wrote:
> > 
> > > Yes, that's certainly wrong, but that's an implementation issue. I was
> > > more concerned about the design of the API.
> > > 
> > > Naively, I would expect a reads on a signalfd to return either process
> > > signals or thread signals targeted towards the thread doing the read.
> > > 
> > > What it actually does (delivering process signals or thread signals
> > > targeted towards the thread that created the signalfd) is weird.
> > > 
> > > For one, it means you can't create a single signalfd, stick it in an
> > > epoll set, and then wait on that set from multiple threads.
> > 
> > In your box threads do share the sighand, don't they? :)
> > 
> 
> I have no idea what you're trying to say, but it doesn't appear to
> address the issue I raise.

"For one, it means you can't create a single signalfd, stick it in an
 epoll set, and then wait on that set from multiple threads."

Why not?
A signalfd, like I said, is attached to the sighand, that is shared by the 
threads.



- Davide


