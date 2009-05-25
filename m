Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZEYWDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZEYWDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZEYWCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:02:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40908 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZEYWCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:02:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Tue, 26 May 2009 00:02:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090509135452.GE10859@elf.ucw.cz> <1243245214.16743.90.camel@nigel-laptop>
In-Reply-To: <1243245214.16743.90.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260002.55500.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Nigel Cunningham wrote:
> Hi.
> 
> On Sat, 2009-05-09 at 15:54 +0200, Pavel Machek wrote:
> > > This is going to sound arrogant, but please don't take it that way: I
> > > can't see any other way of putting it. I don't *think* my code is
> > > better. It is better. swsusp has essentially stood still since Pavel
> > > first forked the code and got it merged. Yes, you have done some
> > > great
> > 
> > I don't think _I_ forked anything.
> 
> The conversation for May 2002 (around when you got it merged into
> vanilla) is here:
> 
> https://sourceforge.net/mailarchive/forum.php?forum_name=swsusp-devel&max_rows=100&style=flat&viewmonth=200205
> 
> Not sure why Sourceforge wants you to log in to get at it.
> 
> > > work on improving the code too and yes, you've done your work on the
> > > version that was already merged. But your changes been more in the area
> > > of fixing/improving what's already there than adding new and useful
> > > features. On the other side, I've continued to improve the code,
> > 
> > Yes, that's fair. We kept incremental fixing, improving. On the other
> > hand, you added new features.
> > 
> > > new features (support for multiple swap partitions & files, for writing
> > > to ordinary files, for mulithreaded I/O etc etc) making it more useful
> > > and more reliable. There are some new features that have been put in
> > > swsusp, but in just about every case (I think there might be an
> > > exception or two), they're things TuxOnIce had for ages before. eg: SMP
> > > support came with cpu hotplugging in 2.6.12 or so. TuxOnIce had SMP
> > > support in 2.4.
> > 
> > You were moving faster because you did not have to move in small
> > incremental steps, and you were allowed to add temporary hacks into
> > the code. Is that surprising? Not to me.
> 
> No, I moved in small incremental steps too - and the odd big rework.
> 
> > [Please update http://www.tuxonice.net/features pages. They are
> > misleading; yes, uswsusp supports threaded writes, can be reconfigured
> > without rebooting and yes we did test failure paths, it can be
> > scripted, and it supports checksums. I don't know what you mean by
> > kexec support, but kexec/kjump could be used as whole another method
> > of hibernating a machine, basically adding fourth row to your table.]
> 
> uswsusp supports multithreaded I/O? Wow. When did that happen?
> 
> Okay. How do you reconfigure it without rebooting (I mean tell it to
> write the image to a different location)? (So I can put the instructions
> on the page).
> 
> Regarding kexec, I'm thinking about making TuxOnice able to do a kexec
> jump and then continue with writing the image (after preparing it in the
> original kernel).
> 
> (Note to self for later - look above for other things Pavel says uswsusp
> can do when updating the page).
> 
> > > > > I take a modular approach and you have everything hardwired.
> > > > 
> > > > That's because using modules woudn't really make sense for us. :-)
> > > 
> > > I'm not saying modules but modular. TuxOnIce has support for compression
> > > neatly abstracted into one file, for swap in another and so on.
> > > [u]swsusp doesn't.
> > 
> > uswsusp has compression neatly abstracted into userland. I still
> > believe that's superior to kernel module.
> 
> Okay, but what about swap support? Modifying swsusp or uswsusp to write
> to ordinary files would require a huge change in multiple places -

Not at all, it acutally works in uswsusp (I still hate this name) as is.

> where you store the image isn't currently abstracted at all from the issue of
> what you're storing, and I dare say a person with a slow computer who
> gets no advantage out of compression will have to recompile uswsusp to
> turn it off (if that's allowed for).

Again, not at all, there's a configuration option allowing you to switch
compression on/off (just like encryption, multithreaded I/O and a few other
things).

But that's just for the record, because I'm really far away from saying that
uswsusp (who gave this name to it?) is "the ultimate hibernation solution" for
Linux.  In fact, I think it is suboptimal for a few good reasons and I'd like
to improve Linux hibernation.  One way to achieve this goal is to join forces
with your project.

At the moment we have some working code showing quite well what's generally
doable, but whether or not we'll finally do it this way is another matter.

Best,
Rafael
