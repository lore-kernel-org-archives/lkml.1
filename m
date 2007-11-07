Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbXKGWPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbXKGWPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbXKGWPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:15:33 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:31009 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754806AbXKGWPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:15:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KfoHKGEAQxL9GAzmABVdEfusuqyLDyzrOPkr031UwziE5HgX3nBYrEviFYy0Gzsqgdn/f9k0hXO6sgetim3n+AN4RTGBVr0u4d6053I1hxPMEtZbLiikyyf56hHYOsqhVSig2ty6ifymlt7Hvun9hsVwUQO/bI/+GtyXfOSFF4w=  ;
X-YMail-OSG: GyYag5gVM1kGJP8EeizkissZkn_D2b.teUtttP1WgNwlkUVkjj3nk4lth5SmMMSC7S4CjtR_dmbDp8aEXSZrEtvOGPVNx04nMIeuPqontbV2DNmR71YPY0nhRW9X
From: David Brownell <david-b@pacbell.net>
To: David Miller <davem@davemloft.net>
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function `usbnet_set_settings':
Date: Wed, 7 Nov 2007 14:15:28 -0800
User-Agent: KMail/1.9.6
Cc: randy.dunlap@oracle.com, toralf.foerster@gmx.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, greg@kroah.com
References: <200711012024.57412.toralf.foerster@gmx.de> <200711011632.18333.david-b@pacbell.net> <20071107.002007.00442348.davem@davemloft.net>
In-Reply-To: <20071107.002007.00442348.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711071415.29234.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007, David Miller wrote:
> David, I hate to say this and point you out like this, but you are a
> real cancer for bug fixes to USB things in the kernel,

You didn't hate it enough to find a way to deal with your issue
that doesn't involve namecalling or other flamage, I'll note.

I know, I know ... you wouldn't want anyone to get the mistaken
impression that LKML is one of those easy-to-get-along-on mailing
lists.  Namecalling helps prevent anyone from ever thinking that!


> If I had a nickel for every patch from someone else you grinded into
> the ground and stalled I'd truly be a millionare.

Hyperbole helps too...

Twenty million patches, surely from some large fraction of a
million kernel patch submitters ... what a crazy dream!
(An enviable one, maybe; but way below the last statistics
on the subject which I read.)

As for "grind into the ground and stall" ... clearly that's
not how I'd describe things.


> You absolutely stifle development progress.  I thought my OHCI
> deadlock patch was an isolated case (and nothing is still applied,
> which is just awesome, my original patch was posted more than a month
> ago),

I'm not sure why the patch I signed off on didn't merge either;
that was specificially related to the OHCI part of that problem.

Hmm, digging through my mail I see several other patches doing
the same thing were also floating around.  None of them had any
improvement over what I had signed off on.  Maybe there was just
too much confusion for Greg to want to merge the one which I'd
already signed off on...


It hasn't been removed from my merge queue, since it's not yet
shown up from kernel.org ... which means that it'd be one of
the patches to be resubmitted before we get much deeper into
this particular RC series.  In fact, I just resent it (with a
few minor tweaks, essentially comment updates).


Of course, *YOU* are the roadblock on the more generic side of
that problem.  I don't recall hearing back from you about the
minor/obvious update to the HUB+EHCI patch adding a msleep()
to bypass the hardware race you reported.

That is, other than your refusal to even try letting the three
or more clock domains finish synchronizing, before releasing
that lock and then starting something that relied on that synch
having finished...


>       but you're doing the same exact thing to Adrian here too.

Hmm, and there I was prepared to sign off on Adrian's last patch.
True, I hadn't yet done so.  But there were several workable fixes
in hand, plus a trivial workaround ... I just didn't make time to
try that one out over the weekend.

I'm glad you grabbed the patch I would have signed off on, if I'd
had time to verify it.


> You want to see things fixed your way.  But you can get away with the
> if, and only if, you can spend every day working on your own version
> of fixes when you don't like the submitters version.

You know, that's hardly a standard kernel-wide policy for how
maintainers work ... except maybe ones in "supported" areas,
and not always even then.

Though I certainly know why it could seem attactive to want that
treatment for patches you submit. I know many of us would just love
to get that level of response/support for everything we submit.
I don't always get it; in some areas, it *never* happens.

In fact, it's pretty routine to have patches wait for a while
before they get merged, or even sometimes reviewed ... where
"a while" will sometimes cover many (annoying) months.


Also, some maintainers demand many iterations of patches, without
doing *any* fixup themselves.  It's as if ... hmm ... maybe there
were only so many hours per day going into that such stuff?  Or as
if people had different priorities?  Bizarre notions, I know!!


>       But unlike me
> you don't have that luxury so you have to give patch submitters a
> larger level of freedom and, plainly, just "let go".

Same goes for maintainers too, you know.  If you're still
wondering about a patch, a private "ping" is common practice;
far more so than public vilification.

In fact, it's best if you never use a public vilification step.
Certainly not until after conventional measures ("ping!") fail
repeatedly, and bad faith has been clearly shown.  (Neither of
which apply in this case.)


