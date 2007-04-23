Return-Path: <linux-kernel-owner+w=401wt.eu-S1751778AbXDWHyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbXDWHyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXDWHyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:54:20 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:56648
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750773AbXDWHyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:54:19 -0400
Date: Mon, 23 Apr 2007 09:57:22 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: "Eddie C. Dost" <ecd@atecom.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Message-ID: <20070423075722.GE10339@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	"Eddie C. Dost" <ecd@atecom.com>,
	Kyle Moffett <mrmacman_g4@mac.com>, chas@cmf.nrl.navy.mil,
	linux-kernel@vger.kernel.org
References: <20070422213959.GP5013@traven> <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com> <20070423065520.GR5013@traven> <20070423071608.GA15338@gannet> <20070423074026.GC10339@traven> <20070423074019.GA14549@gannet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423074019.GA14549@gannet>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

El Mon, Apr 23, 2007 at 09:40:19AM +0200 Eddie C. Dost ha dit:

> as long as mutexes are not converted to nop when CONFIG_SMP is not
> defined (I don't know what current kernels do), this is of course
> correct. You need to verify the headerfiles for the above.

i just checked this, neither the mutex header nor implementation files
handle things different for CONFIG_SMP. 

thanks for your comments

> On Mon, Apr 23, 2007 at 09:40:26AM +0200, Matthias Kaehlcke wrote:
> > El Mon, Apr 23, 2007 at 09:16:08AM +0200 Eddie C. Dost ha dit:
> >  
> > > Please note that the semaphore is used to lock the idt77252 config
> > > tables among multiple users including atmsigd even on single processor
> > > machines. Does this work with mutexes?
> > 
> > afaik mutexes have the same behaviour as binary semaphores that are
> > used as mutexes (always locked and unlocked by the same
> > process/thread):
> > 
> > ".. the semaphore type can officially be considered to be on its way
> > out. New code should not use semaphores, and old code which uses
> > semaphores as mutexes should be converted over when an opportunity
> > presents itself."
> > 
> > http://lwn.net/Articles/167034/
> > 
> > please correct me if i'm wrong, i'm just doing my first steps with
> > linux kernel development

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             You must have a plan. If you don't have a plan,
               you'll become part of somebody else's plan
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
