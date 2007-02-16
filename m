Return-Path: <linux-kernel-owner+w=401wt.eu-S1946029AbXBPR5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946029AbXBPR5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946034AbXBPR5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:57:44 -0500
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:36411 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946029AbXBPR5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:57:43 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 12:57:43 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=oR86Kum24cOKpeE5bSQPcbxNsCekXqHkMwMBd3k+gm5tTfAsrwxjSai2P673NbFvQ2BTDJ93zcwICOAGo+P7znVP68I/PBSf6MWtiCe5fscMMHAutX97K9QV+z9mRbH0YcMgJL9k5d6CNm57kqxUKghkJBEMtMy8fh+cYgN85Yk=  ;
X-YMail-OSG: Wxf823YVM1klxwyLgUVXPk8Sk_Jbqb.4dpsfgO8RdxrqHHhObCm5wDGKxZ9S.P9fDyC1.c2WO4YAG62ODfSzvTHPCRr0gRiVxm3BfLHdd5EKL5CFpo2Uz0nJtwyrH9ytbQmndXomwQ3Wrdw-
Message-ID: <45D5EF5C.3080405@sbcglobal.net>
Date: Fri, 16 Feb 2007 11:52:28 -0600
From: Matthew Frost <artusemrys@sbcglobal.net>
Reply-To: artusemrys@sbcglobal.net
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: v j <vj.linux@gmail.com>
CC: Scott Preece <sepreece@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>	 <20070215061149.GE15654@redhat.com>	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>	 <20070215165339.GB5285@thunk.org>	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>	 <7b69d1470702151705h297c3b38g138eb0138b900aea@mail.gmail.com> <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
In-Reply-To: <9b3a62ab0702151800r3fdb6d64offc6e1de5837b4fd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v j wrote:
> Assuming these need not be GPL, I have a problem with
> EXPORT_SYMBOL_GPL and the general trend in the direction of making
> proprietary drivers harder on companies. Our drivers use basic
> interfaces in the kernel like open, read, write, ioctl, semaphores,
> interrupts, timers etc. This is functionality we would expect from any
> operating system. We used devfs before and had no problems there. Greg
> KH has gone and made the basic sysfs interface, which any generic
> driver could use as EXPORT_SYMBOL_GPL. I don't really care, I just
> don't use sysfs. The point is that old functionality is being ripped
> off and new ones introduced, and their interfaces are not open
> anymore. Hence there will be a point where non-GPLed drivers simply
> cannot be loaded.

And you really should look at why devfs was removed.  It had nothing to do with
closing interfaces.  It had to do with the code itself, and I really should say
nothing more about devfs without my nomex jockeys on.  In replacement, in 2.5,
sysfs evolved.  You can't just point at Greg and say "He's the one stopping me
from doing what I want!"  This is a standard kernel interface, agreed upon by
the usual "rough consensus and running code" methodology.  It simply happens to
be the case that the new code respects a reality which evolved with sysfs
development.  Tainting the kernel on non-GPL module insertion dates from 2001,
early 2.4-series.  Just for a quick google-grep, you can find a very early
explanation for a similar problem in an article by Jerry Epplin, dated March 4,
2001, here:

http://www.linuxdevices.com/articles/AT9161119242.html

Your "3 years ago" timeline surely comes after this information was available.
The reality has changed somewhat, as can be expected over six years and many
arguments and legal consultations.  However, if you do your research, as much as
we'd love to be able to simply ignore non-GPL (especially binary,
no-source-available) modules, we don't.  They just can't use much that is
Linux-unique, and practically nothing that is new.  If you could compile this as
a driver for any UNIX, using POSIXly available interfaces, you would have far
fewer problems.  Any standard syscall that you could get from any standard
(UNIX) operating system, just like you say that you expect.  Or you can do the
nVidia dance, and have to adjust what you can use that is exported, as that
patently non-standard interface changes.  But for your average fire-and-forget
embedded space, that dance only usually gets done once per release.

Your problem is double, of course, because you *distribute non-GPL drivers in a
running Linux*, which is commonly acknowledged to be a problem.  We can't help
you there.  We don't even want to.  And you have it easy!  You just don't like
the idea of releasing your code.  You can't say "Oh, we incorporate patented and
trade secret information which we licensed but cannot divulge".  You're doing it
to yourself.

Sorry,
Matt
