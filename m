Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbXJaRLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbXJaRLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbXJaRKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:10:53 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:37617 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbXJaRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:10:52 -0400
Date: Wed, 31 Oct 2007 18:10:51 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Ram <vshrirama@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel processes - are they really needed?
Message-ID: <20071031171051.GG6092@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Jan Kara <jack@suse.cz>, Ram <vshrirama@gmail.com>,
	linux-kernel@vger.kernel.org
References: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com> <20071031160142.GC28809@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031160142.GC28809@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, Oct 31, 2007 at 05:01:42PM +0100 Jan Kara ha dit:
 
> >     When i do ps -l. i see the following processes which are obviously
> > started by kernel.
> > 
> >    Could any one tell me what each of these processes do and can
> > anyone of them can be removed.?
>   I'll write what I know :)

i'll also put my 0.5 cents :)

> > PID  Uid     VmSize Stat Command
> >     1 root        584 S   init
> >     2 root            SWN [ksoftirqd/0]

executes (on CPU 0) the deferred parts of interrupt routines (bottom
halves), i.e. softirqs and tasklets. bad candidate for removal imo

> >     3 root            SW  [watchdog/0]
> >     4 root            SW< [events/0]

this one is in charge of executing deferred functions placed in the
default work queue. also a bad candidate for removal

> >     5 root            SW< [khelper]
> >     6 root            SW< [kthread]
> >    23 root            SW< [kblockd/0]
>   This one has something to do with block layer - like unplugging
> request queue after a certain timeout etc.
> 
> >    38 root            SW  [pdflush]
> >    39 root            SW  [pdflush]
>   Doing writeback of dirty data.
> 
> >    40 root            SW< [kswapd0]
>   Swapping pages in and out.
> 
> >    41 root            SW< [aio/0]
>   Kernel thread handling asynchronous IO.
> 
> >    85 root            SW  [mtdblockd]
> >   116 root            SWN [jffs2_gcd_mtd9]
>   jffs2 specific - ask a maintainer :) (and mtdblockd has something to
> do with MTD devices so he may know that one as well).

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

                If you don't know where you are going,
               you will probably end up somewhere else
                         (Laurence J. Peter)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
