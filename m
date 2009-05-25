Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZEYJv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZEYJv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZEYJvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:51:52 -0400
Received: from mail.crca.org.au ([67.207.131.56]:45249 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbZEYJvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:51:51 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090509135452.GE10859@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905081611.41865.rjw@sisk.pl> <1241819569.19600.281.camel@nigel-laptop>
	 <200905090046.21282.rjw@sisk.pl> <1241825408.19600.384.camel@nigel-laptop>
	 <20090509135452.GE10859@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 25 May 2009 19:53:34 +1000
Message-Id: <1243245214.16743.90.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2009-05-09 at 15:54 +0200, Pavel Machek wrote:
> > This is going to sound arrogant, but please don't take it that way: I
> > can't see any other way of putting it. I don't *think* my code is
> > better. It is better. swsusp has essentially stood still since Pavel
> > first forked the code and got it merged. Yes, you have done some
> > great
> 
> I don't think _I_ forked anything.

The conversation for May 2002 (around when you got it merged into
vanilla) is here:

https://sourceforge.net/mailarchive/forum.php?forum_name=swsusp-devel&max_rows=100&style=flat&viewmonth=200205

Not sure why Sourceforge wants you to log in to get at it.

> > work on improving the code too and yes, you've done your work on the
> > version that was already merged. But your changes been more in the area
> > of fixing/improving what's already there than adding new and useful
> > features. On the other side, I've continued to improve the code,
> 
> Yes, that's fair. We kept incremental fixing, improving. On the other
> hand, you added new features.
> 
> > new features (support for multiple swap partitions & files, for writing
> > to ordinary files, for mulithreaded I/O etc etc) making it more useful
> > and more reliable. There are some new features that have been put in
> > swsusp, but in just about every case (I think there might be an
> > exception or two), they're things TuxOnIce had for ages before. eg: SMP
> > support came with cpu hotplugging in 2.6.12 or so. TuxOnIce had SMP
> > support in 2.4.
> 
> You were moving faster because you did not have to move in small
> incremental steps, and you were allowed to add temporary hacks into
> the code. Is that surprising? Not to me.

No, I moved in small incremental steps too - and the odd big rework.

> [Please update http://www.tuxonice.net/features pages. They are
> misleading; yes, uswsusp supports threaded writes, can be reconfigured
> without rebooting and yes we did test failure paths, it can be
> scripted, and it supports checksums. I don't know what you mean by
> kexec support, but kexec/kjump could be used as whole another method
> of hibernating a machine, basically adding fourth row to your table.]

uswsusp supports multithreaded I/O? Wow. When did that happen?

Okay. How do you reconfigure it without rebooting (I mean tell it to
write the image to a different location)? (So I can put the instructions
on the page).

Regarding kexec, I'm thinking about making TuxOnice able to do a kexec
jump and then continue with writing the image (after preparing it in the
original kernel).

(Note to self for later - look above for other things Pavel says uswsusp
can do when updating the page).

> > > > I take a modular approach and you have everything hardwired.
> > > 
> > > That's because using modules woudn't really make sense for us. :-)
> > 
> > I'm not saying modules but modular. TuxOnIce has support for compression
> > neatly abstracted into one file, for swap in another and so on.
> > [u]swsusp doesn't.
> 
> uswsusp has compression neatly abstracted into userland. I still
> believe that's superior to kernel module.

Okay, but what about swap support? Modifying swsusp or uswsusp to write
to ordinary files would require a huge change in multiple places - where
you store the image isn't currently abstracted at all from the issue of
what you're storing, and I dare say a person with a slow computer who
gets no advantage out of compression will have to recompile uswsusp to
turn it off (if that's allowed for).

> > > > It doesn't disappoint me that you don't won't to replace [u]swsusp with
> > > > TuxOnIce. I never thought you or Pavel would want to do that.
> > > > 
> > > > I did hold out a little hope that you at least might be supportive
> > > > anyway of getting TuxOnIce added into vanilla - 
> > > 
> > > That would take lot of work and we'd also have to ask many other busy people
> > > to do a lot of work for us.  I think it's better to just avoid it at this point.
> > 
> > I just don't see why you think that. As I said in another reply, there's
> > no work for arch maintainers, very little for mm people and nothing for
> > filesystem maintainers in what I've sent.
> 
> Mainline [u]swsusp does not have ability to save all the memory,
> because that code was deemed too hard to review by mm people. At that
> time, that piece of code was nicely separated 300 line diff.

Okay. That will be a nicely separated diff later too (assuming I get
that far), but the groundwork will be laid well before that little diff
goes in.

Regards,

Nigel

