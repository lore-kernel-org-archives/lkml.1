Return-Path: <linux-kernel-owner+w=401wt.eu-S1751164AbXIKNlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164AbXIKNlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbXIKNl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:41:27 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:44089 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbXIKNl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:41:26 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix failure to resume from initrds.
Date: Tue, 11 Sep 2007 23:41:20 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: nigel@suspend2.net, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>
References: <200709111354.25689.nigel@nigel.suspend2.net> <200709111512.35348.rjw@sisk.pl> <200709111523.33968.rjw@sisk.pl>
In-Reply-To: <200709111523.33968.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709112341.21225.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tuesday 11 September 2007 23:23:32 Rafael J. Wysocki wrote:
> On Tuesday, 11 September 2007 15:12, Rafael J. Wysocki wrote:
> > On Tuesday, 11 September 2007 13:55, Rafael J. Wysocki wrote:
> > > On Tuesday, 11 September 2007 13:27, Nigel Cunningham wrote:
> > > > Hi.
> > > > 
> > > > On Tuesday 11 September 2007 21:04:22 Rafael J. Wysocki wrote:
> > > > > On Tuesday, 11 September 2007 05:54, Nigel Cunningham wrote:
> > > > > > Hi all.
> > > > > > 
> > > > > > Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make 
kernel 
> > > > threads
> > > > > > nonfreezable by default) breaks freezing when attempting to resume 
from an
> > > > > > initrd, because the init (which is freezeable) spins while waiting 
for 
> > > > another
> > > > > > thread to run /linuxrc, but doesn't check whether it has been told 
to 
> > > > enter
> > > > > > the refrigerator.
> > > > > 
> > > > > Hm.
> > > > > 
> > > > > I use a resume from an initrd on a regular basis and it works 
without the 
> > > > patch
> > > > > below.
> > > > > 
> > > > > I think we need to investigate what happens in your test case a bit.
> > > > 
> > > > Ah. That makes me realise that I see that too - my AMD64 uniprocessor 
laptop 
> > > > didn't need the patch (guess that's why I didn't notice the need and 
ack'd 
> > > > the patch). But my x86 SMP machine... it needs this. I'll see if 
they're 
> > > > running on different processors.
> > > 
> > > Well, strange.  My x86_64 SMP machines don't need the patch too.
> > 
> > Anyway, yes, init is freezable, but should it be?
> > 
> > I mean, shouldn't we rather add PF_NOFREEZE to kernel_init()?
> 
> Argh, no.  PF_NOFREEZE is inherited by the children.
> 
> So, I think that your patch is correct, but there's some suspend2-specific
> stuff in it.  I've rediffed it against 2.6.23-rc6 and moved try_to_freeze()
> before yield().

Ah yeah. Sorry about that. Is there some reason I've forgotten that makes the 
order of try_to_freeze & yield in a loop like this matter?

By the way, I had a go at getting fuse processes frozen today. Seems to be 
doable if you take a freeze filesystems prior to processes approach. I've got 
a lot more testing and a bit of cleaning up to do before I'd want to show it 
to anyone, but did successfully do cycles with sshfs, fuseiso and curlftpfs. 
Of course I don't seriously expect it to get merged - everyone's too much in 
love with kexec at the moment :)

Regards,

Nigel
-- 
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.
