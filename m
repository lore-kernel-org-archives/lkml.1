Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbXIETmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbXIETmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbXIETmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:42:10 -0400
Received: from web90413.mail.mud.yahoo.com ([216.252.100.165]:29341 "HELO
	web90413.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932114AbXIETmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:42:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=wJCedJvh+AUM2Q9GdGpCqjHnsvBNXIGwB8voKj+Ww5QtZr6wTvM74+pG4MCDGWNdwKCnUKr5C7PElCUH+1/j74c4IGVaaZdP2wiSIC3a43Wy6GXon8pdLQd+B2bZm1CN6BLOiB5/h3kmoP4Q5laWJf74in2l3rGe8EpnNBvsAlM=;
X-YMail-OSG: 9V4ZY1cVM1lmnm29_Lz3pj9Vts6Q_DXDHumbA8klY4ZrVEUSwDWBgSApUwtkV0DZuIfv4g3Bd0oeYzomZalq6Of1xhjcv785TmmFogEogsKcVbqTQ6pfpLN0JnnJ.Q--
Date: Wed, 5 Sep 2007 12:42:07 -0700 (PDT)
From: James Corey <ploversegg@yahoo.com>
Subject: Re: sk98lin for 2.6.23-rc1
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       Rob Sims <lkml-z@robsims.com>
Cc: Adrian Bunk <bunk@stusta.de>, Kyle Rose <krose@akamai.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070905102230.10b0bdcf@oldman>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <782111.42803.qm@web90413.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Hemminger
<shemminger@linux-foundation.org> wrote:

> On Sun, 29 Jul 2007 21:01:30 -0600
> Rob Sims <lkml-z@robsims.com> wrote:
> 
> > On Thu, Jul 26, 2007 at 06:57:01PM +0200, Adrian
> Bunk wrote:
> > > On Thu, Jul 26, 2007 at 11:16:36AM -0400, Kyle
> Rose wrote:
> > > > >From
> http://www.krose.org/~krose/computing.html:
> > > > 
> > > > Since the sky2 driver continues to suck ass
> (which is a technical
> > > > description for "it hangs all the time under
> load, at least on my
> > > > hardware" :-) ), I've fixed the sk98lin driver
> to compile for
> > > > linux-2.6.23-rc1. Those who continue to have
> problems with sky2 can
> > > > still use 2.6.23-rc1, simply by doing the
> following:
> > > >...
> > > > Personally, I'd like to see sk98lin remain in
> the kernel proper until
> > > > sky2 goes at least 6 months without reported
> problems.  The fact that I
> > > > am not the only one still seeing issues is a
> clear indication that sky2
> > > > (even with the recent patches in 2.6.23-rc1)
> is not yet ready to replace
> > > > sk98lin.
> > > >...
> > > 
> > > This sounds good in theory.
> > > 
> > > The practical problem with this approach is that
> there are always many 
> > > people who use the old driver when the new
> driver doesn't work for them 
> > > instead of reporting their problems with the new
> driver.
> > > 
> > > For these people a new driver will often suck
> when the old driver gets 
> > > removed, but after the removal of the old driver
> they are finally forced 
> > > to report their bugs resulting in a better new
> driver for everyone.
> > > 
> > > The sky2 driver is since nearly 2 years in the
> kernel and Stephen is 
> > > usually quite good at handling bugs.
> > 
> > The driver still (2.6.20/sky2 1.13) hangs for me
> (more rarely than in
> > the past), and cycling the module generally fixes
> the issues.  I have
> > supplied all the information that Stephen has
> asked for, but still no
> > resolution.  I am not complaining about the lack
> of a fix, but don't
> > assume that all it takes to get sky2 working is
> adequate bug reports.  I
> > have been and remain willing to test and assist
> debug, but after several
> > dropped threads, I feel like the desire or ability
> to fix this issue
> > isn't there (and remote debug of an intermittent
> hardware issue IS
> > hard), and I didn't want to be a nuisance to
> someone that has no
> > obligation to me to address the issue in the first
> place.
> > 
> > Stability has improved, it's just not there yet.
> > 
> > I'll switch to 1.16 soon, and respond to Stephen's
> request on netdev for
> > current issues.
> > -- 
> > Rob
> 
> The only known outstanding problems on 2.62.22.6 of
> sky2 are:
>  * problems with fibre PHY based systems
>  * suspend/resume issues, missing multicast
> reinitalization, etc.
> The previous stability problems have been addressed.

I pretty much agree with everything said, including 
the part about the sky2 people working hard on it. I
have noticed several bugs fixed recently in the driver
source.

However, it really DOES lock up under load. I even 
tried 2.6.23-rc4 and the absolute latest version of
the
driver and it still locks up, as in

eth1: hw csum failure.

Call Trace:
 <IRQ>  [<ffffffff804779b6>]
__skb_checksum_complete_head+0x43/0x56
 [<ffffffff804779d5>] __skb_checksum_complete+0xc/0x11
 [<ffffffff804a989d>] tcp_v4_rcv+0x14e/0x801
 [<ffffffff8048ff84>] ip_local_deliver+0xca/0x14c
 [<ffffffff80490472>] ip_rcv+0x46c/0x4ae
 [<ffffffff88006138>] :sky2:sky2_poll+0x72b/0x9c7
 [<ffffffff80245979>] update_wall_time+0x28c/0x39b
 [<ffffffff8047c934>] net_rx_action+0xa8/0x166
 [<ffffffff8023901c>] do_timer+0x10/0xab
 [<ffffffff80235ced>] __do_softirq+0x55/0xc4
 [<ffffffff8020c5cc>] call_softirq+0x1c/0x28
 [<ffffffff8020d6fd>] do_softirq+0x2c/0x7d
 [<ffffffff8020d9bb>] do_IRQ+0x13e/0x15f
 [<ffffffff8020a780>] mwait_idle+0x0/0x48
 [<ffffffff8020b951>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff804acdb9>] udp_poll+0x0/0xfb
 [<ffffffff8020a7c2>] mwait_idle+0x42/0x48
 [<ffffffff8020a718>] cpu_idle+0xbd/0xe0
 [<ffffffff80704a5a>] start_kernel+0x2ac/0x2b8
 [<ffffffff80704140>] _sinittext+0x140/0x144

As far as I can tell, this bug has been with the
sky2 driver all the way back to the Beforetime.
Based on it happening with various versions of the
driver back to 2.6.18 that I have tried, plus some
googling on it.

So while I bug reporting point is a good one, it would
be nice to have a reliable driver in the kernel until
the sky2 one is better. The alternative is to use
the vendor driver, which less than optimal.

-J



      ____________________________________________________________________________________
Fussy? Opinionated? Impossible to please? Perfect.  Join Yahoo!'s user panel and lay it on us. http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 

