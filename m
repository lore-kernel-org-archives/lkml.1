Return-Path: <linux-kernel-owner+w=401wt.eu-S965792AbXCIMYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965792AbXCIMYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965796AbXCIMYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:24:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:46929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965792AbXCIMYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:24:30 -0500
Date: Fri, 9 Mar 2007 13:24:17 +0100
From: Nick Piggin <npiggin@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] futex: restartable futex_wait?
Message-ID: <20070309122417.GA15325@wotan.suse.de>
References: <20070307153349.GA32404@wotan.suse.de> <20070308172902.GA16834@elte.hu> <20070309051038.GA12479@wotan.suse.de> <1173433115.3999.2.camel@chaos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173433115.3999.2.camel@chaos>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 10:38:35AM +0100, Thomas Gleixner wrote:
> On Fri, 2007-03-09 at 06:10 +0100, Nick Piggin wrote:
> > > i think that's quite right. I'm wondering why this never came up before? 
> > > But your fix is not complete i think:
> > > 
> > > > +             restart->arg2 = time;
> > > > +             return -ERESTART_RESTARTBLOCK;
> > > > +     }
> > > 
> > > 'time' here is relative, so the restarted syscall will do a /full/ wait 
> > > again.
> > 
> > But it has been modified by schedule_timeout?
> 
> But this does not change the syscall registers, so it is restarted in
> the same way. We need a new futex OP for this, which takes absolute time
> like the PI futex op does.

Forgive me if I'm missing something here, but I'm using the restart block
and saving the updated value of time in ->arg2, and using that as the new
time parameter passed into futex_wait from futex_wait_restart.

