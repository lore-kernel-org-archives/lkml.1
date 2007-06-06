Return-Path: <linux-kernel-owner+w=401wt.eu-S965275AbXFFWgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965275AbXFFWgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964943AbXFFWge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:36:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2635 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965139AbXFFWgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:36:32 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 6 Jun 2007 15:36:30 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs,
 losing TIF_SIGPENDING and other woes)
In-Reply-To: <1181112452.31677.220.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706061533590.10383@alien.or.mcafeemobile.com>
References: <1181006711.31677.97.camel@localhost.localdomain> 
 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org> 
 <1181009413.31677.117.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com> 
 <1181013756.31677.123.camel@localhost.localdomain>  <1181023787.2785.14.camel@entropy>
  <1181028453.31677.127.camel@localhost.localdomain>  <1181087462.2788.8.camel@entropy>
  <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com> 
 <1181088936.2788.10.camel@entropy>  <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com>
  <1181091523.2788.28.camel@entropy>  <1181098204.31677.158.camel@localhost.localdomain>
  <Pine.LNX.4.64.0706052022430.23673@alien.or.mcafeemobile.com> 
 <alpine.LFD.0.98.0706052035410.4205@woody.linux-foundation.org>
 <1181112452.31677.220.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Benjamin Herrenschmidt wrote:

> On Tue, 2007-06-05 at 20:37 -0700, Linus Torvalds wrote:
> 
> > I agree that it would be a limitation, but it would be a sane one.
> > 
> > How about we try to live with that limitation, if only to avoid the issue 
> > of having the private signals being stolen by anybody else. If we actually 
> > find a real-live use-case where that is bad in the future, we can re-visit 
> > the issue - it's always easier to _expand_ semantics later than it is to 
> > restrict them, so I think this thread is a good argument for starting it 
> > out in a more restricted form before people start depending on semantics 
> > that can be nasty..
> 
> Here's a patch. Let me know if I missed something.
> 
> Fix races with signalfd and TIF_SIGPENDING
> 
> We must never clear TIF_SIGPENDING for another task. This patch
> ensures that by preventing recalc_sigpending_tsk() from clearing
> that bit if the target task is not current.
> 
> In addition we also prevent __dequeue_signal() from calling the
> DRM notifier thingy when stealing signals from another task via
> signalfd.
> 
> Finally, we only dequeue shared signals when called from another
> task (via signalfd), we leave private signals alone.

Makes sense...



> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


