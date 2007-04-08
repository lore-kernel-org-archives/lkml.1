Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbXDHQbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbXDHQbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 12:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXDHQbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 12:31:31 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45155 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751443AbXDHQba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 12:31:30 -0400
Date: Sun, 8 Apr 2007 18:31:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Valdis.Kletnieks@vt.edu
Cc: Krzysztof Halasa <khc@pm.waw.pl>, johnrobertbanks@fastmail.fm,
       Jan Harkes <jaharkes@cs.cmu.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
Message-ID: <20070408163131.GA6296@stusta.de>
References: <461596DE.2020802@zytor.com> <1175823288.25662.1183293506@webmail.messagingengine.com> <4615C780.5040407@zytor.com> <1175833931.8916.1183307802@webmail.messagingengine.com> <20070406152119.GC4228@delft.aura.cs.cmu.edu> <1175914056.9653.1183426876@webmail.messagingengine.com> <20070407033049.GI4228@delft.aura.cs.cmu.edu> <1175925525.21154.1183436614@webmail.messagingengine.com> <m34pns46l9.fsf@maximus.localdomain> <13684.1175965831@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <13684.1175965831@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 01:10:31PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 07 Apr 2007 16:11:46 +0200, Krzysztof Halasa said:
> 
> > > Think about it,... read speeds that are some FOUR times the physical
> > > disk read rate,... impossible without the use of compression (or
> > > something similar).
> > 
> > It's really impossible with compression only unless you're writing
> > only zeros or stuff alike. I don't know what bonnie uses for testing
> > but real life data doesn't compress 4 times. Two times, sometimes,
> 
> All depends on your data.  From a recent "compress the old logs" job on
> our syslog server:
> 
> /logs/lennier.cc.vt.edu/2007/03/maillog-2007-0308:       85.4% -- replaced with /logs/lennier.cc.vt.edu/2007/03/maillog-2007-0308.gz
> 
> And it wasn't a tiny file either - it's a busy mailserver, the logs run to
> several hundred megabytes a day.  Syslogs *often* compress 90% or more,
> meaning a 10X compression.
> 
> > but then it will be typically slower than disk access (I mean read,
> > as write will be much slower).
> 
> Actually, as far back as 1998 or so, I was able to document 20% *speedups*
> on an AIX system that supported compressed file systems - and that was from
> when a 133mz PowerPC 604e was a *fast* machine.   Since then, CPUs have gotten
> faster at a faster rate than disks have, even increasing the speedup.
> 
> The basic theory is that unless you're sitting close to 100%CPU, it is *faster*
> to burn some CPU to compress/decompress a 4K chunk of data down to 2K, and then
> move 2K to the disk drive, than it is to move 4K.  It's particularly noticable
> for larger files - if you can apply the compression to  remove the need to move
> 2M of data faster than you can move 2M of data, you win.

Counterpoints:
- not only CPUs have became faster, RAM has become faster, too
  a kernel tree after an allyesconfig build is at about 1 GB which is 
  less than half the size of RAM in my desktop computer
  if all disk accesses are asynchronous write accesses without any 
  pressure of being done quickly, compression can't improve performance
- today, much of the bigger data is already compressed data like mp3s
  or movies
- for cases like logfiles or databases, application specific compression
  should give best results

There might be special cases where compressed filesystems make sense, 
but my impression is that filesystem compresssion is not important and 
suited for current average systems.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

