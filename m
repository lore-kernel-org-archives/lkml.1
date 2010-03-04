Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0CDMze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 07:55:34 -0500
Received: from stoneboat.aleph1.co.uk ([80.68.88.63]:57871 "EHLO
	stoneboat.aleph1.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab0CDMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 07:55:32 -0500
X-Greylist: delayed 1935 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Mar 2010 07:55:32 EST
Date: Thu, 4 Mar 2010 12:34:22 +0000
From: Wookey <wookey@wookware.org>
To: linux-kernel@vger.kernel.org
Message-ID: <20100304123420.GW27571@dream.aleph1.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003021451.59773.arnd@arndb.de>
Organization: Aleph One Ltd
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 213.165.225.113
X-SA-Exim-Mail-From: wookey@wookware.org
Subject: Re: yaffs2 NAND fs
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on stoneboat.aleph1.co.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please keep me cc:ed - I'm not on this list]

Arnd bergmann wrote:
> On Tuesday 02 March 2010, Peter Paul wrote:
> > I was wondering why the yaffs2 file system has not gone for mainline
> > yet.  
>
> I would guess it's a combination of multiple reasons:
>
> 1. It has not been submitted for upstream inclusion, at least not
>    during the last few years.
> 2. We don't have a staging area like drivers/staging for file systems
>    in the way that we have for drivers
> 3. There is now ubifs and (soon) logfs upstream, both of which appear
>    to be superior to yaffs in many ways.

As someone who has been involved with YAFFS from the beginning I can
give you the reasons (not that they are particularly good ones).

It's about 70%-80% simple inability to keep up with kernel
development, combined with a certain amount of lack of enthusiasm by
some developers and a certain amount of pushback from the MTD people.

Every time we get it vaguely up to date, the kernel has moved on again
before we get round to submitting it. This is of course a reason for
getting it in, not keeping it out, as I am painfully aware, but you
have to get over that effort hump at least once, and we haven't
managed it yet (in nearly 7 years! - oh the embarassment). The closest
we got was about a year ago when I was publically harrangued by Mr
Woodhouse at CELF on exactly this point so I did actually take the
sources and take out all the crap we keep for compatibility with old
kernel versions and checked that the results worked, and removed miles
of trainling whitespace. Then I started going through the list of
things necessary before patches should be submitted but didn't manage
to finish and actually post it for review before something else became
more urgent for a bit. I got to the bit about not dropping single huge
entire-filesystem patches if possible, and foolishly considered if it
could be split up at all. I concluded that it couldn't (or at least I
couldn't), but whilst I'd dithered there was a new kernel out so now I
was too late again and it stalled till now.

YAFFS is in the process of moving to git, which will make it easier to
maintain a 'mainlinable' branch so we can have another go at this
process.

On more ancient history there was not much enthusiasm for mainline
when YAFFS started. The author didn't feel it was ready and the fact
that it is designed, and supported, for numerous OSes, not just Linux,
and our deliberate support of old kernels, meant it contained a lot of
non-current-linux cruft which of course is not appropriate in
mainline. 

Later we did want to put it in, but struggled to keep up and get it in
a suitable state, and then things in MTD world changed (2006ish?) such
that filesystems that actively used the OOB area were frowned upon and
we got the strong impression it wouldn't be accepted anyway. So then
there was a long pause until YAFFS gained the ability to run without
using the OOB ('in-band tags'). That happened sometime in 2008, hence
my failed effort in 2009 to try and get this sorted.

So, I agree YAFFS should be in mainline (as someone who has to patch
it into my kernels on a daily basis this would make my life much
easier too). I don't know if it is really 'too late' in terms of the
existence of UBIFS and LOGFS. I don't think so - YAFFS is a
sufficicently different approach that I reckon it still makes sense
for plenty of people, but I guess that's something to debate.

I suppose the thing I stalled on before doing this last time was 'What
is the best approach for getting a great big dollop of a filesystem
like this reviewed'? I was relunctant to send in one 250K patch, but
couldn't really see a better way, and if doing that, it probably
needed quite a detailed supporting explanation. The other thing that
kept me from doing it was that I knew there would be a pile of changes
requested and there was no point kicking off the process unless I knew
I'd be able to devote so time to it afterwards to deal with comments.
Problem is, that never seems to occur.

So, I guess this is another kick. I'll update the mainline patch I
have (which is essentially just YAFFS2 with all the "#ifdef kernel
nnn" code taken out, and the YAFFS-direct and ecos and WinCE code
removed, to current kernel (which also means updating balloon3 to current
kernel so I can actually test it). I'll put that in git and ask people
to take a look. Detailed suggestions on what extra info is needed or
changes made would be very helpful.

Unless of course there is already concensus that this is a waste of
time and Peter and I are the only people that want to see it in
mainline?

Wookey
-- 
Principal hats:  iEndian - Balloonboard - Toby Churchill - Emdebian
http://wookware.org/
