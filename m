Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYFWNri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYFWNri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYFWNr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:47:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31984 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbYFWNr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:47:27 -0400
Date: Mon, 23 Jun 2008 15:47:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>, linux-acpi@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: LMSENSORS: 2.6.26-rc,  enabling ACPI Termal Zone support costs
   sensors
Message-ID: <20080623154715.3ac8e984@hyperion.delvare>
In-Reply-To: <485F9877.1060902@keyaccess.nl>
References: <485DA11C.7050906@keyaccess.nl>
	<485DFF35.6080008@hhs.nl>
	<485E505F.8010306@keyaccess.nl>
	<485E61DE.6020202@hhs.nl>
	<20080623120844.5f722aa6@hyperion.delvare>
	<485F79C6.20507@keyaccess.nl>
	<20080623135704.2980078c@hyperion.delvare>
	<485F9877.1060902@keyaccess.nl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

FYI: this is my last reply to you as far as this thread is concerned. I
have work to do, and this problem is already solved.

On Mon, 23 Jun 2008 14:35:03 +0200, Rene Herman wrote:
> On 23-06-08 13:57, Jean Delvare wrote:
> 
> > On Mon, 23 Jun 2008 12:24:06 +0200, Rene Herman wrote:
> 
> >> No Jean, this is totally unacceptable. No matter how you want to call 
> >> things, 2.6.26 is going to break important functionality on millions of 
> >> systems and you simply do not get to do that.
> > 
> > No, it's not going to be the end of the world that you predict. Please
> > stop being alarmist, it really doesn't help.
> > 
> > We are going to break hardware monitoring for users who upgrade to
> > kernel 2.6.26 by themselves and have enabled option "THERMAL"
> 
> Which is an option selected by ACPI_THERMAL, for which I quoted the help 
> text earlier. Basically everyone with ACPI enabled will have it enabled. 
> Rather wide-spread, that is.

Correct, I had forgotten that it was enabled by ACPI_THERMAL. So indeed
pretty much everyone using lm-sensors will have it.

> > and are using lm-sensors <= 2.10.6. I suspect this is a relatively
> > small number of users
> 
> Yes, right. All not completely new systems, all completely new slackware 
> and derived systems... "relatively" is a word very much needed here.

Slackware 12.1 shipped with a 2.6.25 kernel and this isn't going to
change. So I am absolutely not worried about Slackware users in
general. The only users who will hit the breakage are the ones
upgrading their kernel themselves, and that's regardless of the
distribution.

> I really cannot believe you guys are actually arguing this. It seems 
> that me being tired and short pulled this in to senseless country but 
> can we please concentrate on the issue?

When you have the feeling that everybody else has gone crazy and you're
the only sane person on-board... you know what it really means? ;)

> libsensors dictated the ABI rule that the hwmon directories must have 
> device backlinks; the new ACPI Thermal Zone hwmon interface breaks that 
> bit of ABI. It is not relevant that that ABI may have gotten to be as a 
> result of unfortunate programming on the userspace side -- the only 
> thing relevant is that it IS. lm-sensors 2 is on millions of systems out 
> there.

We don't care about how many systems use lm-sensors 2. We only care
about how many of these will upgrade to kernel 2.6.26 before they
upgrade to lm-sensors 2.10.7 or patch their lm-sensors 2.10.6. My take
is that these aren't that many people.

Seriously, the kind of "ABI breakage", as you insist on calling it,
happens all the time. Just looking at sensors and only counting the
very big changes, sensors were exposed in /proc in 2.4 kernels and are
now exposed in /sys in 2.6 kernels, and all hardware monitoring devices
were i2c devices to the kernel until kernel 2.6.13 and this is no
longer the case. Just try going a couple lm-sensors versions back while
still running your 2.6.25 kernel and you'll see it won't take long
before at least a specific case breaks.

And I'm fairly certain that we (the lm-sensors group) aren't specially
bad at that. Every other subsystem that evolves quickly must have the
same problems. That's exactly the reason why we have user-space
libraries interfacing with the kernel. When the kernel interfaces
evolve, we update the libraries to take the changes into account. It is
usually so smooth that you don't see it. This time it's a bit less
smooth because we've been too slow releasing 2.10.7. You can't get it
perfect all the time.

I'm really sorry that we don't live in an ideal world where everything
is compatible with everything forever.

> This is not meant agressively, or whatever you guys seem to want 
> to read in my words, it's un undeniable fact.
> 
> > and these are also the ones who are presumably skilled enough to go
> > to http://www.lm-sensors.org/, find the patch they need, and apply it
> > to libsensors themselves.
> 
> At times there can obviously be situations where it's fine to require 
> new userspace but in this case we have a new userspace which hasn't even 
> been released yet, we have a ton of _different_ userspace depending  on 
> that bit of core userspace, we have breakage of the important kind (as 
> you no doubt know, sensors can be pretty vital, although admittedly it's 
> not silent breakage at least) and we have an opportunity to just say 
> "okay, we'll apply a 1 line patch and be done with it" which avoids any 
> and all problems. Why are you arguing this?

I'm arguing this because you're trying to frighten everyone with
"kernel ABI breakage" and "millions of users" when all we have is an
unfortunate bug in libsensors, which is already fixed and this fix is
only waiting to be released. Your 1 line patch, as small as it is, is
ugly and could have unexpected side effects.

> >> Can you comment on the last patch posted? It's trivial:
> >>
> >> http://lkml.org/lkml/2008/6/22/243
> > 
> > It's trivial and wrong, so thanks but no thanks. The bug is in
> > libsensors, we fix it in libsensors.
> 
> This cannot be the reason, because it's not wrong. We just need a device 
> backlink. Basically, any single one will do. It's just about keeping 
> lm-sensors 2 happy.

Your patch _is_ wrong. You make the device link point to _one_ of the
devices that belong to the thermal zone, arbitrarily. If the device is
removed before the thermal zone itself is, what happens? Breakage. If
we were to apply your patch just to smooth the transition with the
2.6.26 kernel, then we'd have to rework the code in question later
because it's not correct. And by your own terms, this link would become
part of the ABI, meaning that we could not get rid of it later or even
change it. Who knows? Anyone could have decided to use the link for
whatever purpose.

On top of that, libsensors 2 is going to do something with the device
link you created. I'm curious how you can guarantee that there won't be
any side effect, given that the devices in question were never meant to
be processed by libsensors.

You are looking at the problem you've hit and you are trying to solve
it, and this is great. But in the end you have to admit that you don't
really know the code you're touching. You did not read the whole
thermal zone code to understand how it was working. You did not read
the whole libsensors 2.10.x code to know for sure what will happen when
it follows the device link you want to add. I guess you also did not
read the whole libsensors 3.0.x code to make sure that adding this link
would have no unexpected side effect. So it's about time that you trust
the guys who wrote the code and are maintaining it for years when they
say that they have fixed the problem in the best possible way.

Thanks,
-- 
Jean Delvare
