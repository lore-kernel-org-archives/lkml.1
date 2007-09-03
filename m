Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbXICMu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbXICMu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXICMuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:50:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbXICMuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:50:16 -0400
Date: Mon, 3 Sep 2007 05:49:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: folkert@vanheusden.com, linux-kernel@vger.kernel.org, jack@ucw.cz,
       a.p.zijlstra@chello.nl
Subject: Re: [2.6.22] circular lock detected
Message-Id: <20070903054959.3ecd9576.akpm@linux-foundation.org>
In-Reply-To: <20070903122702.GC29908@atrey.karlin.mff.cuni.cz>
References: <20070824210033.GB13237@vanheusden.com>
	<20070902045529.c66eddc9.akpm@linux-foundation.org>
	<20070903122702.GC29908@atrey.karlin.mff.cuni.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 3 Sep 2007 14:27:02 +0200 Jan Kara <jack@suse.cz> wrote:
> > > On Fri, 24 Aug 2007 23:00:33 +0200 Folkert van Heusden <folkert@vanheusden.com> wrote:
> > > Hi,
> > > 
> > > 2.6.22 kernel with hyperthreading enabled only ext3 filesystems (2).
> > > 
> > > [  346.314640] =======================================================
> > > [  346.314758] [ INFO: possible circular locking dependency detected ]
> > > [  346.314815] 2.6.22 #5
> > > [  346.314862] -------------------------------------------------------
> > > [  346.314920] tor/2421 is trying to acquire lock:
> > > [  346.314973]  (tty_mutex){--..}, at: [<c121aa83>] mutex_lock+0x8/0xa
> > > [  346.315193] 
> > > [  346.315195] but task is already holding lock:
> > > [  346.316203]  (&s->s_dquot.dqptr_sem){----}, at: [<c10a485f>] dquot_alloc_space+0x50/0x189
> > > [  346.316457] 
> > > [  346.316458] which lock already depends on the new lock.
>
> ...
>
> > > [  346.353603]  =======================
> > > 
> > Has been reported before, but I don't recall whether we fixed it.  Jan,
> > do you know>?
>   I think we at least found a solution: Teach lockdep that I_MUTEX for
> different filesystems is different. Peter Zilstra wrote a patch for that
> and Folkert even confirmed that it fixes the problem for him. I'm not
> sure what happened with the patch afterwards though. Adding Peter to CC
> :).

But this is a tty_lock-versus-dqptr_sem ranking error.  Unrelated to i_mutex?
