Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYEAEgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYEAEgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 00:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYEAEgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 00:36:00 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:42978 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751601AbYEAEf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 00:35:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O3juJDbR+veCgS6bZideIdrI6fD5Efh64ggyDNSjSuE0AMMSzcl8aB+wWVdVMoN5+ukeBjhLTVjqi9WVzFba3MDrQ83R/NxY1wBHLvMPYJl8sxFOj2V6q9z9MyOqKtKlko56TNh38t95/jNtbMsWyhCl1OKLyWAvCAg4shBrdgg=  ;
X-YMail-OSG: NFsPXbcVM1lxTMjUR6ThIPmIdC3QOeUu0mWeqK5dcT0KrzdfYenHmzwcMd2cKe9ECnodIu9X58ftzwmizKYSb9fqF2QsWlH0jY6f0EAA6bzpT0rRBy3FWTYywkyp_V_63QuwZAZSkHZoeFFJKG7BuV0H
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
Date: Wed, 30 Apr 2008 21:35:55 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Ben Nizette <bn@niasdigital.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <200804301908.32346.david-b@pacbell.net> <Pine.LNX.4.64.0804301931030.1537@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0804301931030.1537@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804302135.56529.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008, Trent Piepho wrote:
> >>>    /sys/class/gpio
> >>>    	...
> >>
> >> "simple"?  What I had was a lot simpler.
> >
> > But it had some "must fix" problems, which I told you when you
> > posted your first patch.  You didn't fix them.  And since then,
> > your pushback seems to rely very heavily on ignoring issues I
> > pointed out are "must fix" or "can't/doesn't work that way".
> 
> So what are these must fix problems? 

Not fixed in any update you sent to your original patch, in
the past three weeks, that's the key point.  In particular,
the number one issue was completely ignored.  (Your recent
responses haven't come across to me as helpful either..)


> You say nothing in sysfs works this way, but I don't agree.  Take a look at
> /sys/class/net, you have names like "tap0", "eth0", "eth1", "lo", etc.  This
> is exactly what I'm saying to do.  The first "eth" gpio chip you register is
> appears as eth0 in sysfs, the second as eth1, and so on.

So, when I said that sysfs doesn't use names like "gpio-19" but instead
uses names like "gpio19" ... exactly what don't you agree with?

Your examples prove what I *did* say.  I don't know who you're trying
to argue with on other points, however.


> >> So, I want to set gpio 5 on a pcf9557 extender.
> >
> > Which isn't exactly where most folk start.  If it's something
> 
> It's where I started.

Which is fine.  The $SUBJECT patch provides a simple solution for it.
As well as for the other use cases I sketched.  With identifiers that
are much simpler, and harder to get wrong.


> You say your system works for everything that matters 
> and just dismiss the problems I'm solving as irrelevant with a wave of your
> hand.  That's very convenient for you, but where does it leave me?

Those are *NOT* my words.  Again, I don't know what straw man you
are arguing with, but please stop painting my face on it, putting
your words in its mouth, and using that to claim you're disproving
something I've "said" (but haven't).

I did say your problem could be solved ... but with different
identifier syntax than you suggested.


> Your worried about the memory usage of some extra sysfs files, but include
> python on your device?  IMHO, if you can't do this simple task in 5 minutes
> with just busybox, the system is making things too hard.

Right, and since I *can* do stuff like that in busybox with ASH,
that quickly, I hope you'll agree your flamage has been blowing
things way out of proportion here.

 
> What is the reason to not have the label with gpio in sysfs?

Elaborated in my reply to Ben; see that.


> How does seeing the value, direction, and label of a gpio "muck around with
> its internal state?"

Userspace being able to MODIFY the direction and output value
is most certainly mucking around!!!


> Of course, one can still change a gpio via /dev/mem or i2c-dev, depending on
> the source.  How is being able to do this via sysfs any different?

It's a question of how easy you make it to break things.
You seem to draw the "too easy" line differently than I do.
I don't want *anything* else mucking around with state my
drivers are responsible for managing.



