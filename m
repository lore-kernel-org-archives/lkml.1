Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXFSDy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXFSDy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 23:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763743AbXFSDyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 23:54:19 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54615 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762706AbXFSDyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 23:54:19 -0400
To: Debbugs developers <debian-debbugs@lists.debian.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: This is [Re:] How to improve the quality of the kernel[?].
In-Reply-To: <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172053.41806.bzolnier@gmail.com> <20070617115258.1f55b29d.akpm@linux-foundation.org> <200706172349.08813.bzolnier@gmail.com> <4675C083.6080409@s5r6.in-berlin.de> <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org>
Cc: Martin Bligh <mbligh@mbligh.org>, Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <andi@firstfloor.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 19 Jun 2007 06:06:47 +0200
Message-Id: <E1I0UzP-0004AY-Hy@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Dear Debbug developers, i wish your ideas will be useful.]

* From: Linus Torvalds
* Newsgroups: gmane.linux.kernel
* Date: Mon, 18 Jun 2007 17:09:37 -0700 (PDT)
>
> On Mon, 18 Jun 2007, Martin Bligh wrote:
>> 
>> Sorry to be a wet blanket, but I've seen those sort of things
>> before, and they just don't seem to work, especially in the
>> environment we're in with such a massive diversity of hardware.
>
> I do agree. It _sounds_ like a great idea to try to control the flow of 
> patches better,

There were some ideas, i will try to summarize:

* New Patches (or sets) need tracking, review, testing

  Zero (tracking) done by sending (To, or bcc) [RFC] patch to something
  like submit@pts.e-mail.example.com (like BTS now). Notifications will
  be sent to intrested maintainers (if meta-information is ok) or testers
  (see below)

  First is mostly done by maintainers or interested individuals.
  Result is "Acked-by" and "Cc" entries in the next patch sent. Due to
  lack of tracking this things are done manually, are generally in
  trusted manner. But bad like <200706172053.41806.bzolnier@gmail.com>
  sometimes happens.

  When patch in sent to this PTS, your lovely
  checkpatch/check-whatever-crap-has-being-sent tools can be set up as
  gatekeepers, thus making impossible stupid errors with MIME coding,
  line wrapping, whatever style you've came up with now in checking
  sent crap.

* Tracking results of review (Acked-by).

  This can be mostly e-mail exchange with comments and agreements.
  "Acked-by" semantic may be implemented in form of contlol message to
  tracking system, and this system will generate e-mail confirmation
  to the patch author in form of
  "Acked-by: Developer's Name <message-id of e-mail with acke-by>"

  Thus, next patch will have this entry. And if testing of this
  version ir regression happens, there's info about who is/was
  interested/involved.

* Testing.

  Mainly same for "Tested-by"
  (newly suggested by Stefan <4675C083.6080409@s5r6.in-berlin.de>)

|-*- Feature Needed -*-
  Addition, needed is hardware user tested have/had/used. Currently
  ``reportbug'' tool includes packed specific and system specific
  additions automaticly gathered and inserted to e-mail sent to BTS.
  (e.g. <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/29740>)

  Formats of that hardware profile(as system information in reportbug)
  . arch
  . chipset
  . hdd
  . vga
  ...
  in meaningful fields, and not just lspci -v[vv]. If additional info
  (-vvv) or something required, profile can be exteded.

  For kernel's sub-system information(as packed info):
  . subsystem/driver/kernel version (or similar)
  . maintainers must know what they need to see more here

|-*- back to patches -*-

  Last and not least tast cases, that everyone might came up with.

  All formats this can be agreed (or implemented and updated latter)
  and inserted automaticly.

* Commit.
  Id is recorded, patch archived. But any additions are welcome,
  regressions will pop up this patch again (reopen in BTS).

> but in the end, it needs to also be easy and painfree to the people
> involved, and also make sure that any added workflow doesn't require
> even *more* load and expertise on the already often overworked 
> maintainers..

Experienced BTS users and developers. Please, correct me if i'm wrong.
At least e-mail part of Debian's BTS and whole idea of it is *exactly*
what is needed. Bugzilla fans, you can still use you useless pet,
because Debian developers have done things, to track and e-mail states
of bugs: <http://permalink.gmane.org/gmane.linux.debian.devel.kernel/29736>

> In many cases, I think it tends to *sound* great to try to avoid 
> regressions in the first place - but it also sounds like one of those "I 
> wish the world didn't work the way it did" kind of things. A worthy goal, 
> but not necessarily one that is compatible with reality.

I wish perl hackers out there will join this yet-new effort. I know
there many of them out there, writing kilobytes of checkfile and
checkpatch (i've wrote in few lines of ``sed'').

BTS is written on perl, but any interoperability interface, like
stdin/stdout for python or shell hackers is worth of thinking about.

Please, see more and make useful follows ups: http://bugs.debian.org/

Please, do not (<46772321.9080602@mbligh.org>)
""" I know you hate bugzilla ... but at least I can try to make that bit
    of the process work better.
""" [here's you fancy checkbox...]

Thanks.
____
