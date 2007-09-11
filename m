Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbXIKTOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbXIKTOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764012AbXIKTNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:13:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36616 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763372AbXIKTNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:13:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@suspend2.net
Subject: Re: [PATCH] Fix failure to resume from initrds.
Date: Tue, 11 Sep 2007 21:25:14 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>
References: <200709111354.25689.nigel@nigel.suspend2.net> <200709111523.33968.rjw@sisk.pl> <200709112341.21225.nigel@nigel.suspend2.net>
In-Reply-To: <200709112341.21225.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709112125.15421.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 September 2007 15:41, Nigel Cunningham wrote:
> Hi.
> 
> On Tuesday 11 September 2007 23:23:32 Rafael J. Wysocki wrote:
> > On Tuesday, 11 September 2007 15:12, Rafael J. Wysocki wrote:
> > > On Tuesday, 11 September 2007 13:55, Rafael J. Wysocki wrote:
> > > > On Tuesday, 11 September 2007 13:27, Nigel Cunningham wrote:
> > > > > Hi.
> > > > > 
> > > > > On Tuesday 11 September 2007 21:04:22 Rafael J. Wysocki wrote:
> > > > > > On Tuesday, 11 September 2007 05:54, Nigel Cunningham wrote:
> > > > > > > Hi all.
> > > > > > > 
> > > > > > > Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make 
> kernel 
> > > > > threads
> > > > > > > nonfreezable by default) breaks freezing when attempting to resume 
> from an
> > > > > > > initrd, because the init (which is freezeable) spins while waiting 
> for 
> > > > > another
> > > > > > > thread to run /linuxrc, but doesn't check whether it has been told 
> to 
> > > > > enter
> > > > > > > the refrigerator.
> > > > > > 
> > > > > > Hm.
> > > > > > 
> > > > > > I use a resume from an initrd on a regular basis and it works 
> without the 
> > > > > patch
> > > > > > below.
> > > > > > 
> > > > > > I think we need to investigate what happens in your test case a bit.
> > > > > 
> > > > > Ah. That makes me realise that I see that too - my AMD64 uniprocessor 
> laptop 
> > > > > didn't need the patch (guess that's why I didn't notice the need and 
> ack'd 
> > > > > the patch). But my x86 SMP machine... it needs this. I'll see if 
> they're 
> > > > > running on different processors.
> > > > 
> > > > Well, strange.  My x86_64 SMP machines don't need the patch too.
> > > 
> > > Anyway, yes, init is freezable, but should it be?
> > > 
> > > I mean, shouldn't we rather add PF_NOFREEZE to kernel_init()?
> > 
> > Argh, no.  PF_NOFREEZE is inherited by the children.
> > 
> > So, I think that your patch is correct, but there's some suspend2-specific
> > stuff in it.  I've rediffed it against 2.6.23-rc6 and moved try_to_freeze()
> > before yield().
> 
> Ah yeah. Sorry about that. Is there some reason I've forgotten that makes the 
> order of try_to_freeze & yield in a loop like this matter?

Technically it's not that important, but conceptually try_to_freeze() should
happen right after we've been woken up.

> By the way, I had a go at getting fuse processes frozen today. Seems to be 
> doable if you take a freeze filesystems prior to processes approach. I've got 
> a lot more testing and a bit of cleaning up to do before I'd want to show it 
> to anyone, but did successfully do cycles with sshfs, fuseiso and curlftpfs.

Sounds promising. :-)
 
> Of course I don't seriously expect it to get merged - everyone's too much in 
> love with kexec at the moment :)

Well, I guess it'll take some time to get that work reliable and it would be
nice to have a fix before it's ready.

Greetings,
Rafael
