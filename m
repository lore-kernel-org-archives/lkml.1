Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXGTFOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXGTFOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbXGTFOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:14:38 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56511
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbXGTFOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:14:36 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Date: Fri, 20 Jul 2007 01:14:27 -0400
User-Agent: KMail/1.9.6
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>, "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       "Krzysztof Halasa" <khc@pm.waw.pl>, "Rod Whitby" <rod@whitby.id.au>,
       "Russell King" <rmk@arm.linux.org.uk>, david@lang.hm
References: <200707171703.31340.rob@landley.net> <200707181339.54192.rob@landley.net> <3ae72650707181633w244904a6l2cee81d307b7dda1@mail.gmail.com>
In-Reply-To: <3ae72650707181633w244904a6l2cee81d307b7dda1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707200114.28654.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007 7:33:19 pm Kay Sievers wrote:
> On 7/18/07, Rob Landley <rob@landley.net> wrote:
> > > >  /sys/block/*/dev
> > > >  /sys/block/*/*/dev
> > >
> > > Note that this will change to /sys/class/block/ in the future.
> >
> > At OLS, Kay Sievers said in a future version they were going to move it
> > to "/sys/subsystem/block", which I can't document right now because no
> > current kernel does this, and that path will never work with any previous
> > kernel, but there should be a compatability symlink from the old path to
> > the new one.
>
> That will be the case.
>
> > He never mentioned /sys/class/block.
>
> So? How about reading your  email?
>   http://marc.info/?l=linux-kernel&m=118260305012165&w=2

It wasn't in the notes you sent me from OLS, and I didn't compare against the 
earlier one because I thought the OLS notes were complete.

> Yes, in this order (if you want to use it, but /sys/block will still be
> there): /sys/subsytem/block/devices/*
>   /sys/class/block/*
>   /sys/block/*/*

"if you want to use it" said to me that sys/class/block/* was optional, so I 
didn't add it to the document I was writing.

> You seem to miss the the very basic skills to collect the needed
> information to do the job of documenting something.

I've gotten a lot of contradictory information, a lot of gratuitous changes 
from previous versions, a lot of notice of as of yet unmerged plans, and a 
lot of useless information (mostly in the form of "don't"s) while researching 
this topic.  I'm trying to find a useful subset.

I asked you what I needed when we met in person, and you didn't 
put /sys/class/block/* in the list.

Sysfs is almost unique in that examining the implementation tells me NOTHING 
about how to use it.  This is a defect in sysfs that I'm attempting to 
rectify by writing documentation about what you can rely on when trying to 
use it for hotplug and firmware loading.  This is a specific, limited use 
that I'm familiar with the requirements for.

Is there anything in /sys/class/block that _isn't_ in /sys/block?  Does "if 
you want to use it, but /sys/block will still be there" NOT mean, as I 
assumed at the time, that I could safely ignore it?  (My impression from the 
meeting at OLS was that adding /sys/block to /sys/class/block had been just 
an idea rejected in favor of adding it to /sys/subsystem/block.  I note that 
neither my Ubuntu 7.04 laptop nor the 2.6.22 system I built has either 
a /sys/class/block or a /sys/subsystem/block, so anything written attempting 
to use that won't work on any currently deployed Linux system.  You can't use 
it today, and will never be able to use it on any kernel version deployed 
today.)

> > To all of this, I would like to humbly ask:
> >
> > PICK ONE!  JUST #*%(&#%& PICK ONE!  AAAAAAAAHHHHHHH!!!!!!!!!
>
> Man, you totally miss the point.

I want to document a stable API, including the subset of sysfs that will 
remain stable.  The "point" appears to be that there isn't one because sysfs 
is "special", and udev should be in the kernel source tarball.

I'm trying to write down here the minimal information needed to find the "dev" 
nodes to populate /dev.  There's no functional reason I'm aware of for them 
to keep moving around.

> > > > Entries for char devices are found at the following locations:
> > > >
> > > >  /sys/bus/*/devices/*/dev
> > > >  /sys/class/*/*/dev
> > >
> > > Uh, that is actually the generic location?
> >
> > It's what Kay Sievers and Greg KH told me at OLS when I tracked them down
> > to ask.  I've also experimentally verified it working on Ubuntu 7.04. 
> > That was cut and pasted from Kay's email, and it works today.
>
> That is still true, but it still does not tell you the type of node to
> create, as you seem to insist on.

I don't insist on it, mknod insists on it.  You cannot mknod a dev node 
without specifying block or char.

You're saying that sysfs should provide major and minor numbers without 
anywhere specifying "char" or "block", meaning the major and minor numbers 
cannot be _used_.  I am insisting on getting the third piece of information 
without which "major" and "minor" are useless.

I asked very specifically about this at OLS, several times.  What you're 
telling me now seems to contradict what you told me then.

What I documented works in today's kernel.  You've talked about adding new 
mechanisms that won't work in today's kernel, which I'm not worrying about as 
long as the mechanisms that work with today's kernel continue to work.  Now 
you say you're going to break today's kernel by adding block devices 
to /sys/class, which I got the impression was NOT going to happen at OLS 
(that it was going to move to sys/subsystem but that sys/block symlink would 
still track it).  I specifically asked "what paths do I need to look at to 
find char devices" and "what paths do I need to look at to find block 
devices", and the paths in the documentation are the ones I got when I asked.

If block is going to move to sys/class, I can put in a warning about this 
pending breakage in the documentation, and modify my example code to filter 
it out.

> > > It may be enough (and less confusing) to just state that the dev
> > > attribute will belong to the associated "class" device sitting
> > > under /sys/class/ (with the current exception of /sys/block/).
> >
> > Nope.  If you recurse down under /sys/class following symlinks, you go
> > into an endless loop bouncing off of /sys/devices and getting pointed
> > back.  If you don't follow symlinks, it works fine up until about 2.6.20
> > at which point things that were previously directories BECAME symlinks
> > because the directories got moved, and it all broke.
>
> That's total nonsense.

Which part, the "following symlinks produced an endless loop" or 
the "directories turned into symlinks so not following them broke?"

Let's see...

According to my blog, Frank Sorensen first sent me a C port of my /dev 
populating script on December 12, 2005.  The current kernel at the time was 
2.6.14, so grab that, build user Mode Linux...  Huh, it won't build with gcc 
4.1.2.  Or 3.4.  Ok, defconfig?  Nope, that wants a stack check symbol?  
Let's see...  Ah, google says add -fno-stack-protector to CFLAGS.  Right...  
Fire it up under qemu, "mount -t sysfs /sys /sys", and:

In 2.6.14, /sys/block/hda/device points 
to ../../devices/pci0000:00/0000:00:01.1/ide0/0.0

/sys/block/hda/device/block points to ../../../../../block/hda

So in 2.6.14 you could 
go /sys/block/hda/device/block/device/block/device/block... endlessly, which 
is the reason I wrote mdev not to follow symlinks but to instead only look at 
actual subdirectories.  (It uses the same code to traverse down 
beneath /sys/block and /sys/class to look for "dev" entries.)  This works 
fine up through the 2.6.20 in ubuntu 7.04, where everything 
in /sys/class/tty/* is still a subdirectory.  But in 2.6.22, /sys/class/tty/* 
is all symlinks.  Hence the code that was working before changed, due to 
something that worked fine for a couple years but broke because it wasn't 
considered part of a stable API.

Which part of this is "total nonsense"?

> > Which is why I want it documented where to look for these suckers.  Just
> > give me ONE STABLE WAY TO FIND THIS INFORMATION, PLEASE.
> >
> > This document is trying to document just enough information to make
> > hotplug work using sysfs (which includes firmware loading if necessary).
> >
> > > (And how about referring to Documentation/sysfs-rules.txt?)
> >
> > Because there isn't one in 2.6.22, and I've been writing this file on and
> > off for a month as I tracked down various bits of information?
>
> I invested a lot of time explaining stuff to you in email and
> personally, but really, that seems just like a total waste of time.

I wrote up a document.  Started writing it before OLS, incorporated the 
information I got from you while at OLS, and took a while tracking down some 
old code doing netlink so I could include enough for people to puzzle out how 
that works.

I would have bounced earlier unfinished drafts off of you, but you were 
spam-blocking my email.  (Might still be, I don't know.  This is why I wanted 
to talk to you in person at OLS.)

> I will not reply to any of your mails

And I _can't_ reply to yours off-list because of your out of control spam 
filter.

> until you have proven to have read 
> the udevtrigger code,

I read the udev code when it was first posted.  I read it again 20 versions 
later, and read it again 20 versions after that.  I couldn't COMPILE the darn 
thing for its first ~40 releases, the code got ripped out and re-written 
several times, I watched as it grew and then threw out libsysfs.

So essentially you're saying "well read it again, we've finally got it right 
now"?

> and got a clue how to do stuff reliably, and get  
> the basic knowledge needed to document it.

Because talking to you and having you email me the notes from this 
conversation did not provide the basic knowledge needed to document hotplug 
and firmware loading.  Nor did asking for feedback on the document I wrote 
up.  Thanks ever so much.

I point out that udev changes from version to version, so that running an old 
version of udev against a new kernel has been known to break.  Udev was more 
or less completely rewritten three times while I was still paying attention 
to it.  Reading the udev code and seeing what it's doing struck me as about 
as likely to reveal a stable API as reading the kernel source, or 
experimenting with sysfs from userspace.  (Both of which I've _done_ at 
various points, and it keeps changing.)

Are you saying that the current version of udev will work with all future 
kernels, and thus if I can figure out what udev is doing today, I can just 
document that as the stable API?

> Kay

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
