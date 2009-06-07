Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZFGRwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZFGRwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 13:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZFGRv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 13:51:56 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41191 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZFGRvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 13:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=aH/Ly1mOZAyZqHO9Zw/L7sbNptQzEYViq0/bXGfyjmQYGxHcJTUegNfypUZcwb24gi
         7ayespw4Dke6Zn60kiNwWccLfcwTQL0fdcRmQ7Cr2LzRMXqsDchX9FIiPgItbgStbksj
         MNg0wci6QP9Go8tTb92XfDb57KfhzvgoRYRPU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [git pull] IDE fixes
Date: Sun, 7 Jun 2009 19:47:19 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200906071444.33047.bzolnier@gmail.com> <200906071744.23629.bzolnier@gmail.com> <1244390889.8262.47.camel@mulgrave.site>
In-Reply-To: <1244390889.8262.47.camel@mulgrave.site>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906071947.19723.bzolnier@gmail.com>
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 June 2009 18:08:09 James Bottomley wrote:
> On Sun, 2009-06-07 at 17:44 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 07 June 2009 17:18:51 you wrote:
> > > On Sun, 2009-06-07 at 16:57 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > > On Sunday 07 June 2009 16:38:56 James Bottomley wrote:
> > > > > On Sun, 2009-06-07 at 15:21 +0100, Alan Cox wrote:
> > > > > > > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> > > > > > > index 99e33ef..4bc2c43 100644
> > > > > > > --- a/fs/partitions/check.c
> > > > > > > +++ b/fs/partitions/check.c
> > > > > > 
> > > > > > 
> > > > > > You seriously want to add code to the core partition handling logic
> > > > > > moments before release when we know we have all sorts of devices with
> > > > > > weird behaviours ?
> > > > > > 
> > > > > > This should be .31 stuff where we can take the time to see how it works
> > > > > > on all sorts of weird real world devices (eg those with 2K sector size)
> > > > > > and the like.
> > > > > 
> > > > > Absolutely seconded.
> > > > > 
> > > > > Plus this is only one of the proposals for dealing with IDE native sizes
> > > > > moving through the process.  The other one is in libata with the gendisk
> > > > > proposal for alt size instead of your set_capacity callback.   The last
> > > > 
> > > > ->set_capacity callback is needed for drivers/ide regardless of alt_size
> > > > sysfs interface and it don't conflict with it in any way.
> > > 
> > > It's used as a heuristic for selecting native vs protected disk size
> > > depending on what the partition table says ... I grant that's one way to
> > > handle the problem.
> > > 
> > > > Those patches are a complimentary work to Tejun's alt_size patches. 
> > > > 
> > > > They don't export anything to user-space.
> > > 
> > > So you're trying to solve the problem heuristically, and Tejun is trying
> > > to provide the user with full information.   At the end of the day it
> > > would be nice to get agreement on how we do this *before* exposing it to
> > > users.  It's certainly possible we could do both, but for that to happen
> > 
> > Sure.  My patches don't export anything to user-space.
> > 
> > If you find any code parts controversial please post them and I'll be
> > more than happy to discuss them in details.
> > 
> > > libata would have to implement .get_capacity() is that going to be the
> > > case?
> > 
> > Now we get the real source of Alan's and your complains...
> > 
> > Those patches (among other things) make IDE superior overt libata w.r.t.
> > HPA handling so libata now has to catch up.
> > 
> > Honestly, this should be solved on technical basis by somebody posting
> > needed libata patches instead of attempts to slow down IDE fixes.
> 
> You've got the wrong motive.  I have notice that you and Alan seem to
> have a somewhat antagonistic relationship resulting in a proxy battle
> over IDE/libata, so you would necessarily see this as at play in his
> first post.  I hoped, by emphasizing the point, that you'd see this

Please don't project your own way of thinking on me or (maybe?) try to
play on imaginary conflict between me and Alan for your own gains.

By emphasizing untrue point -- I have a much respect for Alan for all
his kernel work and also for being a long-term promoter of Linux -- you
are trying to move the discussion from technical means to political ones.

It is true that we get into heated arguments with Alan from time to time
but this is unavoidable given large differences in our views on kernel
development process (I was late to the game so I have very different
experiences that people who were doing it since the beginning) and also
on future directions of progress (i.e. I don't support segregation of
hardware support on "relevant" and "irrelevant" or dropping ISA support).

However as long as we stick to the *code* and discuss things based on the
*code* we have no problems with working together (which happens more often
then not).

[ Who I really have antagonistic relationship with are some smart-asses
  trying to play politics by using other people to do your dirty work
  (and no, I didn't went on hiatus in 2005 because of Alan if some people
  still wonder). ]

When it comes to libata: are you serious?

I gave libata a full green light back when it was introduced in 2003.

What I have been always complaining about w.r.t. libata is too slow
progress and a bit too little long-term planning.

[ Cause I know that we can do better! ]

When it comes libata PATA: "the battle" has been lost back in 2005
(nobody with semi-sane thinking would believe that it could be won),
or more like that there was never any battle since I was always fine
with PATA support in libata (though I was *extremely* unhappy with
the way it was introduced and resulting long-term consequences).

> adding features as bug fixes is a problem even from a more neutral
> perspective.
> 
> So I have two specific problems with the way you're trying to one up
> libata:
> 
>      1. You're trying to get a jump on them by adding features as bug
>         fixes ... this is incredibly bad release practice.

It is a bugfix.  Long overdue one.

However you have to look beyond kernel to see it.  From the commit log:

"
>From the perspective of most users of recent systems, disabling Host
Protected Area (HPA) can break vendor RAID formats, GPT partitions and
risks corrupting firmware or overwriting vendor system recovery tools.

Unfortunately the original (kernels < 2.6.30) behavior (unconditionally
disabling HPA and using full disk capacity) was introduced at the time
when the main use of HPA was to make the drive look small enough for the
BIOS to allow the system to boot with large capacity drives.

Thus to allow the maximum compatibility with the existing setups (using
HPA and partitioned with HPA disabled) we automically disable HPA if
any partitions overlapping HPA are detected.  Additionally HPA can also
be disabled using the "nohpa" module parameter (i.e. "ide_core.nohpa=0.0"
to disable HPA on /dev/hda).
"

Yes, it is true that there is no rush.

OTOH there are absolutely no valid technical reasons to slow it down!

>      2. this antagonism in feature evolution is likely to lead to
>         interface incompatibility between libata and IDE ... and users
>         will be the ultimate losers because of this.

Hmmm, did you *really* read the patches?

They make libata and IDE more similar by making IDE also default to
preserving HPA (which is what libata does).  So users get more coherent
overall kernel behavior.

The only difference is that IDE for compatibility reasons must handle old
installs (with HPA wrongly disabled and protected area used for filesystem
data).

However it does it in a clean way (not a subsystem specific hack) which
can be later used for implementing the same functionality in libata!

[ I also tried to encourage libata developers to look into making the needed
  libata changes (see my initial posting of HPA patches) and I will still be
  glad to help with libata patches if somebody would like to work on them
  (Robert? Tejun?). ]
