Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbYBTRFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbYBTRFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:05:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYBTREv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:04:51 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:57490 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYBTREt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YvdzTLckRqWQfZyHEKP8UMPh3Jy9c9lxu4kUKzU5jyzRqScoWNmi3t9xD/NLaHlpW+iiXc31KKryn4/QNd9Np3VkqQ/uJYY8wwWI9m1q/O3sd2f0/VFBKEx+vGrbqHbu9XrzRUdKs/c/vlIAcnUqAh+R5kLPTQ/QMa+uFLnKOpo=
Message-ID: <c4e36d110802200904x37e49764y2e26c65870eb8161@mail.gmail.com>
Date: Wed, 20 Feb 2008 18:04:47 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Zan Lynx" <zlynx@acm.org>
Subject: Re: Disk schedulers
Cc: "Prakash Punnoor" <prakash@punnoor.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Lukas Hejtmanek" <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <1203095486.6663.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080214162104.GA5347@ics.muni.cz>
	 <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr>
	 <200802151557.59082.prakash@punnoor.de>
	 <1203095486.6663.12.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/15, Zan Lynx <zlynx@acm.org>:
>
> On Fri, 2008-02-15 at 15:57 +0100, Prakash Punnoor wrote:
> > On the day of Friday 15 February 2008 Jan Engelhardt hast written:
> > > On Feb 14 2008 17:21, Lukas Hejtmanek wrote:
> > > >Hello,
> > > >
> > > >whom should I blame about disk schedulers?
> > >
> > > Also consider
> > > - DMA (e.g. only UDMA2 selected)
> > > - aging disk
> >
> > Nope, I also reported this problem _years_ ago, but till now much hasn't
> > changed. Large writes lead to read starvation.
>
> Yes, I see this often myself.  It's like the disk IO queue (I set mine
> to 1024) fills up, and pdflush and friends can stuff write requests into
> it much more quickly than any other programs can provide read requests.
>
> CFQ and ionice work very well up until iostat shows average IO queuing
> above 1024 (where I set the queue number).

I should probably summarize my experience here as well:

I'm using Qemu - inside of it I'm testing some kernel module which is
doing a lot of disk copy operation - its virtual disk has 8GB.  When
my test is started my system starts to feel unresponsive couple times
per minute for nearly 10 minutes - especially if I use some chat tool
like pidgin I'm often left for 5 secs without any visible refresh on
screen (redraw, typed keys,...)  Firefox shows similar symptoms...

Obviously piding has its own responsibility here - because from strace
it's visible it tries to open and read files - that he read already
zillion times before :) - but that's another story.

But I've tried many things - I've started qemu with ionice -c0, used
ionice -c2 for pidgin, tried different io-scheduler, niced qemu,
changed swappiness  to  different values according to various tips &
tricks around the web I could find  and I cannot get properly running
system with my qemu test case because the system feels unresponsive in
some application which needs to touch my drive.

Does anyone have any ideas what should I try/test/check

BTW one interesting things I've noticed is very high kernel IPI number:
i.e.
  77,0% (3794,9)      <kernel IPI> : Rescheduling interrupts

Sometimes this number attacks 10000 barrier.

My machine is 2.2GHz C2D, T61, 2GB - and CPU is 50% idle while machine
freezes - and yes I can move the mouse all the time ;) and no I'm not
out-of-ram

Zdenek
