Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbXCIJjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbXCIJjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993079AbXCIJjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:39:08 -0500
Received: from www.osadl.org ([213.239.205.134]:39809 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752674AbXCIJjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:39:06 -0500
Subject: Re: [rfc][patch] futex: restartable futex_wait?
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070309051038.GA12479@wotan.suse.de>
References: <20070307153349.GA32404@wotan.suse.de>
	 <20070308172902.GA16834@elte.hu>  <20070309051038.GA12479@wotan.suse.de>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 10:38:35 +0100
Message-Id: <1173433115.3999.2.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 06:10 +0100, Nick Piggin wrote:
> > i think that's quite right. I'm wondering why this never came up before? 
> > But your fix is not complete i think:
> > 
> > > +             restart->arg2 = time;
> > > +             return -ERESTART_RESTARTBLOCK;
> > > +     }
> > 
> > 'time' here is relative, so the restarted syscall will do a /full/ wait 
> > again.
> 
> But it has been modified by schedule_timeout?

But this does not change the syscall registers, so it is restarted in
the same way. We need a new futex OP for this, which takes absolute time
like the PI futex op does.

	tglx


