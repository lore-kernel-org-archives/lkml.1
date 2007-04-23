Return-Path: <linux-kernel-owner+w=401wt.eu-S965668AbXDWHjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668AbXDWHjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965663AbXDWHjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:39:08 -0400
Received: from mail.atecom.com ([212.117.69.21]:59629 "EHLO mail.atecom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965668AbXDWHjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:39:07 -0400
X-Greylist: delayed 1373 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2007 03:39:06 EDT
From: "Eddie C. Dost" <ecd@atecom.com>
Date: Mon, 23 Apr 2007 09:16:08 +0200
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Kyle Moffett <mrmacman_g4@mac.com>, chas@cmf.nrl.navy.mil,
       ecd@atecom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
Message-ID: <20070423071608.GA15338@gannet>
References: <20070422213959.GP5013@traven> <45C4C5F0-4F09-416D-A237-82FC28DF1883@mac.com> <20070423065520.GR5013@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423065520.GR5013@traven>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please note that the semaphore is used to lock the idt77252 config
tables among multiple users including atmsigd even on single processor
machines. Does this work with mutexes?

Best regards,
Eddie

On Mon, Apr 23, 2007 at 08:55:20AM +0200, Matthias Kaehlcke wrote:
> El Sun, Apr 22, 2007 at 07:50:36PM -0400 Kyle Moffett ha dit:
> 
> > On Apr 22, 2007, at 17:39:59, Matthias Kaehlcke wrote:
> > >use spinlock instead of binary mutex in idt77252 driver
> > 
> > I think you really meant: "Use mutex instead of binary semaphore in  
> > idt77252 driver", since this is a binary semaphore (not a mutex,  
> > which are always binary):
> > >-	struct semaphore	mutex;
> > 
> > and this is a mutex, not a spinlock:
> > >+	struct mutex		mutex;
> > 
> > Everything else looks good though
> 
> you're totally right. like in another patch i sent at the same time i
> messed up the description. as you point out it should read "Use mutex
> instead of binary semaphore in idt77252 driver". in the last days i
> reported some spinlock related bugs, i suppose that made me write
> spinlock instead of mutex ...
> 
> thanks for your comments
> 
> -- 
> Matthias Kaehlcke
> Linux Application Developer
> Barcelona
> 
>                 If you don't know where you are going,
>                you will probably end up somewhere else
>                          (Laurence J. Peter)
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
