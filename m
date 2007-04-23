Return-Path: <linux-kernel-owner+w=401wt.eu-S965672AbXDWHkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672AbXDWHkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965663AbXDWHkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:40:22 -0400
Received: from mail.atecom.com ([212.117.69.21]:59836 "EHLO mail.atecom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965672AbXDWHkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:40:21 -0400
From: "Eddie C. Dost" <ecd@atecom.com>
Date: Mon, 23 Apr 2007 09:40:19 +0200
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       "Eddie C. Dost" <ecd@atecom.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       chas@cmf.nrl.navy.mil, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Message-ID: <20070423074019.GA14549@gannet>
References: <20070422213959.GP5013@traven> <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com> <20070423065520.GR5013@traven> <20070423071608.GA15338@gannet> <20070423074026.GC10339@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423074026.GC10339@traven>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as long as mutexes are not converted to nop when CONFIG_SMP is not
defined (I don't know what current kernels do), this is of course
correct. You need to verify the headerfiles for the above.

Regards,
Eddie

On Mon, Apr 23, 2007 at 09:40:26AM +0200, Matthias Kaehlcke wrote:
> El Mon, Apr 23, 2007 at 09:16:08AM +0200 Eddie C. Dost ha dit:
>  
> > Please note that the semaphore is used to lock the idt77252 config
> > tables among multiple users including atmsigd even on single processor
> > machines. Does this work with mutexes?
> 
> afaik mutexes have the same behaviour as binary semaphores that are
> used as mutexes (always locked and unlocked by the same
> process/thread):
> 
> ".. the semaphore type can officially be considered to be on its way
> out. New code should not use semaphores, and old code which uses
> semaphores as mutexes should be converted over when an opportunity
> presents itself."
> 
> http://lwn.net/Articles/167034/
> 
> please correct me if i'm wrong, i'm just doing my first steps with
> linux kernel development
> 
> regards
> 
> -- 
> Matthias Kaehlcke
> Linux Application Developer
> Barcelona
> 
>     C treats you like a consenting adult. Pascal treats you like a
>           naughty child. Ada treats you like a criminal
>                       (Bruce Powel Douglass)
>                                                                  .''`.
>     using free software / Debian GNU/Linux | http://debian.org  : :'  :
>                                                                 `. `'`
> gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-

-- 
Christian Dost
Technical Director R&D

ATecoM realizing visions GmbH
Pascalstrasse 67
D-52076 Aachen
Germany
Fon: +49/2408/9596-0
Fax: +49/2408/9596-900
Email: ecd@atecom.com
URL: http://www.atecom.com

Amtsgericht Aachen, HRB# 5941, Sitz: Aachen
Geschaeftsfuehrer: Bernd Leister, Robert Bonnie
USt.-Id. Nr. / VATID: DE 811 66 99 76
Steuernummer/Tax-ID: 225/5775/0558
