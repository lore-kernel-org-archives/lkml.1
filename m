Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbYCLIS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbYCLIS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 04:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYCLISS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 04:18:18 -0400
Received: from phunq.net ([64.81.85.152]:51315 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972AbYCLISO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 04:18:14 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Wed, 12 Mar 2008 00:17:56 -0800
User-Agent: KMail/1.9.5
Cc: Chris Friesen <cfriesen@nortel.com>, Lars Marowsky-Bree <lmb@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803111256.51267.phillips@phunq.net> <20080311205340.GJ8953@1wt.eu>
In-Reply-To: <20080311205340.GJ8953@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120117.57644.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 13:53, Willy Tarreau wrote:
> On Tue, Mar 11, 2008 at 11:56:50AM -0800, Daniel Phillips wrote:
> > On Tuesday 11 March 2008 10:26, Chris Friesen wrote:
> > > I have experienced many 2.6 crashes due to software flaws.  Hung 
> > > processes leading to watchdog timeouts, bad kernel pointers, kernel 
> > > deadlock, etc.
> > > 
> > > When designing for reliable embedded systems it's not enough to handwave 
> > > away the possibility of software flaws.
> > 
> > Indeed.  You fix them.  Which 2.6 kernel version failed for you, what
> > made it fail, and does the latest version still fail?
> 
> Daniel, you're not objective. Simply look at LKML reports. People even
> report failures with the stable branch, and that's quite expected when
> more than 5000 patches are merged in two weeks. The question could even
> be returned to you: what kernel are you using to keep 204 days of uptime
> doing all that you describe ? Maybe 2.6.16.x would be fine, but even then,
> a lot of security issues have been fixed since the last 204 days (most of
> which would require a planned reboot), and also a number of normal bugs,
> some of which may cause unexpected downtime.

So we have a flock of people arguing that you can't trust Linux.  Well
maybe there are situations were you can't, but what can you trust?
Disk firmware?  Bios?  Big maybes everywhere.  In my experience, Linux
is very reliable.  I think Linus, Andrew and others care an awful lot
about that and go to considerable lengths to make it true.  Got a list
of Linux kernel flaws that bring down a system?  Tell me and I will not
use that version to run a transaction processing system, or I will fix
them or get them fixed.

But please do not tell me that Linux is too unreliable to run a
transaction processing system.  If Linux can't do it, then what can?

By the way, the huge ramdisk that Violin ships runs Linux inside, to
manage the raided, hotswappable memory modules.  (Even cooler: they
run Linux on a soft processor implemented on a big FPGA.)  Does anybody
think that they did not test to make sure Linux does not compromise
their MTBF in any way?

In practice, for the week I was able to test the box remotely and the
10 days I had it in my hands, the thing was solid as a rock.  Good
hardware engineering and a nice kernel I say.

> > If Linux is not reliable then we are doomed and I do not care about
> > whether my ramback fails because I will just slit my wrists anyway.
> 
> No, I've looked at the violin-memory appliance, and I understand better
> your goal. Trying to get a secure and reliable generic kernel is a lost
> game. However, building a very specific kernel for an appliance is often
> quite achievable, because you know exactly the hardware, usage patterns,
> etc... which help you stabilize it.

Sure.  Leaving out dodgy stuff like hald, other bits I could mention,
is probably a good idea.  Scary thing is, thinks like hald are actually
being run on servers but that is another issue entirely.

It wasn't too long ago that NFS client was in the dodgy category, with
oops, lockups, whathaveyou.  It is pretty solid now, but it takes a
while for the bad experiences to fade from memory.  On the other hand,
knfsd has never been the slightest bit of a problem.  Helpful
suggestion: don't run NFS client on your transaction processing unit.
It may well be solid, but who needs to find out experimentally?  Might
as well toss gamin, dbus and udev while you are at it, for a further
marginal reliability increase.  Oh, and alsa, no offense to the great
work there, but it just does not belong on a server.  Definitely do
not boot into X (I know I should not have to say that, but...)

> I think people who don't agree with 
> you are simply thinking about a generic file server. While I would not
> like my company's NFS exports to rely on such a technology for the same
> concerns as exposed here, I would love to have such a beast for logs
> analysis, build farms, or various computations which require more than
> an average PC's RAM, and would benefit from the data to remain consistent
> across planned downtime.

I guess I am actually going to run evaluations on some mission critical
systems using the arrangement described.  I wish I could be more specific
about it, but I know of critical systems pushing massive data that in
fact rely on batteries just as I have described.  For completeness, I
will verify that pulling the UPS plug actually corrupts the data and
report my findings.  Not by pulling the plug of course, but by asking
the vendors.

> If you consider that the risk of a crash is 1/year and that you have to
> work one day to rebuild everything in case of a crash, it is certainly
> worth using this technology for many things. But if you consider that
> your data cannot suffer a loss even at a rate of 1/year, then you have
> to use something else.

I consider 1/year way too high a failure rate for anything that gets
onto a server I own, and then there must necessarily be systems in
place to limit the damage.  For me, that means replication, or perhaps
synchronously mirroring the whole stack which is technology I do not
trust yet on Linux, so we don't do that.  Yet.

So here is the tradeoff: do you take the huge performance boost you
get by plugging in the battery, and put the necessary backup systems
in place or do you accept a lower performing system that offers higher
theoretical reliability?  It depends on your application.  My
immediate application happens to be hacking kernels and taking diffs
which tends to suck rather badly on Linux.  Ramback will fix that, and
it will be in place on my workstation right here, I will give my
report.  (Bummer, I need to reboot because I don't feel like backporting
to 2.6.20, too bad about that 205 day uptime, but I have to close the
vmsplice hole anyway.)  So I will have, say, a 3 GB source code
partition running under ramback and it will act just like spinning
media because of my UPS, except 25 times faster.

Of course the reason I feel brave about this is, everything useful
on that partition gets uploaded to the internet sooner rather than
later.  Nonetheless, having to reinstall everything would cost me
hours, so I will certainly not do it if I think there is any
reasonable likelihood I might have to.

> BTW, I would say that IMHO nothing here makes RAID impossible to use :-)
> Just wire 2 of these beasts to a central server with 10 Gbps NICs and
> you have a nice server :-)

Right.  See ddraid.  It is in the pipeline, but everything takes time.
We also need to reroll NBD complete with deadlock fixes before I feel
good about that.

Regards,

Daniel
