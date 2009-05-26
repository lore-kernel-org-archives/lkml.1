Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbZEZWhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbZEZWhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZEZWha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:37:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48314 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbZEZWh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:37:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@tuxonice.net
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Wed, 27 May 2009 00:37:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905260002.55500.rjw@sisk.pl> <1243297196.16743.137.camel@nigel-laptop>
In-Reply-To: <1243297196.16743.137.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905270037.43991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Nigel Cunningham wrote:
> Hi.
> 
> On Tue, 2009-05-26 at 00:02 +0200, Rafael J. Wysocki wrote:
> > On Monday 25 May 2009, Nigel Cunningham wrote:
> > > On Sat, 2009-05-09 at 15:54 +0200, Pavel Machek wrote:
> > > > > This is going to sound arrogant, but please don't take it that way: I
> > > > > can't see any other way of putting it. I don't *think* my code is
> > > > > better. It is better. swsusp has essentially stood still since Pavel
> > > > > first forked the code and got it merged. Yes, you have done some
> > > > > great
> > > > 
> > > > I don't think _I_ forked anything.
> > > 
> > > The conversation for May 2002 (around when you got it merged into
> > > vanilla) is here:
> > > 
> > > https://sourceforge.net/mailarchive/forum.php?forum_name=swsusp-devel&max_rows=100&style=flat&viewmonth=200205
> > > 
> > > Not sure why Sourceforge wants you to log in to get at it.
> > > 
> > > > > work on improving the code too and yes, you've done your work on the
> > > > > version that was already merged. But your changes been more in the area
> > > > > of fixing/improving what's already there than adding new and useful
> > > > > features. On the other side, I've continued to improve the code,
> > > > 
> > > > Yes, that's fair. We kept incremental fixing, improving. On the other
> > > > hand, you added new features.
> > > > 
> > > > > new features (support for multiple swap partitions & files, for writing
> > > > > to ordinary files, for mulithreaded I/O etc etc) making it more useful
> > > > > and more reliable. There are some new features that have been put in
> > > > > swsusp, but in just about every case (I think there might be an
> > > > > exception or two), they're things TuxOnIce had for ages before. eg: SMP
> > > > > support came with cpu hotplugging in 2.6.12 or so. TuxOnIce had SMP
> > > > > support in 2.4.
> > > > 
> > > > You were moving faster because you did not have to move in small
> > > > incremental steps, and you were allowed to add temporary hacks into
> > > > the code. Is that surprising? Not to me.
> > > 
> > > No, I moved in small incremental steps too - and the odd big rework.
> > > 
> > > > [Please update http://www.tuxonice.net/features pages. They are
> > > > misleading; yes, uswsusp supports threaded writes, can be reconfigured
> > > > without rebooting and yes we did test failure paths, it can be
> > > > scripted, and it supports checksums. I don't know what you mean by
> > > > kexec support, but kexec/kjump could be used as whole another method
> > > > of hibernating a machine, basically adding fourth row to your table.]
> > > 
> > > uswsusp supports multithreaded I/O? Wow. When did that happen?
> > > 
> > > Okay. How do you reconfigure it without rebooting (I mean tell it to
> > > write the image to a different location)? (So I can put the instructions
> > > on the page).
> > > 
> > > Regarding kexec, I'm thinking about making TuxOnice able to do a kexec
> > > jump and then continue with writing the image (after preparing it in the
> > > original kernel).
> > > 
> > > (Note to self for later - look above for other things Pavel says uswsusp
> > > can do when updating the page).
> > > 
> > > > > > > I take a modular approach and you have everything hardwired.
> > > > > > 
> > > > > > That's because using modules woudn't really make sense for us. :-)
> > > > > 
> > > > > I'm not saying modules but modular. TuxOnIce has support for compression
> > > > > neatly abstracted into one file, for swap in another and so on.
> > > > > [u]swsusp doesn't.
> > > > 
> > > > uswsusp has compression neatly abstracted into userland. I still
> > > > believe that's superior to kernel module.
> > > 
> > > Okay, but what about swap support? Modifying swsusp or uswsusp to write
> > > to ordinary files would require a huge change in multiple places -
> > 
> > Not at all, it acutally works in uswsusp (I still hate this name) as is.
> > 
> > > where you store the image isn't currently abstracted at all from the issue of
> > > what you're storing, and I dare say a person with a slow computer who
> > > gets no advantage out of compression will have to recompile uswsusp to
> > > turn it off (if that's allowed for).
> > 
> > Again, not at all, there's a configuration option allowing you to switch
> > compression on/off (just like encryption, multithreaded I/O and a few other
> > things).
> > 
> > But that's just for the record, because I'm really far away from saying that
> > uswsusp (who gave this name to it?) is "the ultimate hibernation solution" for
> > Linux.  In fact, I think it is suboptimal for a few good reasons and I'd like
> > to improve Linux hibernation.  One way to achieve this goal is to join forces
> > with your project.
> 
> Re the features, okay. I don't claim to have looked at your code
> recently or in great detail when I did look at it.
> 
> Re the name, I think from memory that I had some input there - made a
> joke or something - and Pavel took me seriously. Sorry!
> 
> Re joining forces, yes please. I have precious little time, too many
> other commitments and would frankly be just as happy to chuck the whole
> thing in - except that I want better hibernation than is in the kernel
> at the moment and am not going to stop using Linux.
> 
> By the way, do you really have multithreaded I/O in uswsusp? If so, what
> sort of throughput are you achieving combined with compression (please
> also quote hdparm -t's speed of the swap partition for comparison).

Well, first, our multithreaded I/O is probably not the same thing as you think
of, because we have an option to use multiple user space threads that process
image data (compress, encrypt and feed them to the kernel).

Now, we found that it only improves performance substantially if both
compression and encryption are used.

As far as the numbers are concerned, I don't have the raw hdparm numbers
handy, but image writing speed with compression alone usually is in the
60 MB/s - 100 MB/s range, sometimes more than 100 MB/s, but that really depends
on the system.  If encryption is added, it drops substantially and multiple
threads allow us to restore the previous performance (not 100%, but close
enough to be worth the additional complexity IMO).

Still, one should always take the total length of hibernate-resume cycle into
accout and the image writing/reading time need not be the greatest part of it.

Best,
Rafael
