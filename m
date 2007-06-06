Return-Path: <linux-kernel-owner+w=401wt.eu-S934251AbXFFEgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251AbXFFEgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXFFEfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:35:52 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3053 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXFFEfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:35:51 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 5 Jun 2007 21:35:50 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs,
 losing TIF_SIGPENDING and other woes)
In-Reply-To: <alpine.LFD.0.98.0706052035410.4205@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706052135030.23673@alien.or.mcafeemobile.com>
References: <1181006711.31677.97.camel@localhost.localdomain> 
 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org> 
 <1181009413.31677.117.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com> 
 <1181013756.31677.123.camel@localhost.localdomain>  <1181023787.2785.14.camel@entropy>
  <1181028453.31677.127.camel@localhost.localdomain>  <1181087462.2788.8.camel@entropy>
  <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com> 
 <1181088936.2788.10.camel@entropy>  <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com>
  <1181091523.2788.28.camel@entropy> <1181098204.31677.158.camel@localhost.localdomain>
 <Pine.LNX.4.64.0706052022430.23673@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0706052035410.4205@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Linus Torvalds wrote:

> On Tue, 5 Jun 2007, Davide Libenzi wrote:
> > On Wed, 6 Jun 2007, Benjamin Herrenschmidt wrote:
> > > 
> > > Yeah, synchronous signals should probably never be delivered to another
> > > process, even via signalfd. There's no point delivering a SEGV to
> > > somebody else :-)
> > 
> > That'd be a limitation. Like you can choose to not handle SEGV, you can 
> > choose to have a signalfd listening to it. Of course, not with the 
> > intention to *handle* the signal, but with a notification intent.
> 
> I agree that it would be a limitation, but it would be a sane one.
> 
> How about we try to live with that limitation, if only to avoid the issue 
> of having the private signals being stolen by anybody else. If we actually 
> find a real-live use-case where that is bad in the future, we can re-visit 
> the issue - it's always easier to _expand_ semantics later than it is to 
> restrict them, so I think this thread is a good argument for starting it 
> out in a more restricted form before people start depending on semantics 
> that can be nasty..

Yeah, that's easy. We can exclude them at signalfd creation time.



- Davide


