Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbXIIKpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbXIIKpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 06:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXIIKpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 06:45:32 -0400
Received: from tzmxr01.htp-tel.de ([81.14.243.17]:45460 "EHLO
	TZMXR01.htp-tel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbXIIKpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 06:45:31 -0400
Message-ID: <46E3CEB0.4030202@leemhuis.info>
Date: Sun, 09 Sep 2007 12:45:04 +0200
From: Thorsten Leemhuis <fedora@leemhuis.info>
User-Agent: Thunderbird 2.0.0.6 (X11/20070813)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Takashi Iwai <tiwai@suse.de>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Andrew Morton <akpm@linux-foundation.org>, roger@computer-surgery.co.uk,
       linux-kernel@vger.kernel.org, perex@suse.cz
Subject: Re: easy alsa patches for the stable kernel?
References: <20070822222902.GA28563@computer-surgery.co.uk>	<20070905083844.6637da1e.akpm@linux-foundation.org>	<s5hlkbl6qsn.wl%tiwai@suse.de>	<20070905091633.87cfaa81.akpm@linux-foundation.org>	<s5hhcm96oza.wl%tiwai@suse.de>	<1189091390.3212.3.camel@rukbat>	<s5hir6n6ck6.wl%tiwai@suse.de>	<1189115313.7275.5.camel@rukbat>	<1189153347.15955.5.camel@rukbat>	<s5h7in26aj3.wl%tiwai@suse.de>	<46E13E31.1050409@leemhuis.info>	<s5hy7fi4oou.wl%tiwai@suse.de>	<46E1A9AC.1050601@leemhuis.info> <s5hsl5qhwqa.wl%tiwai@suse.de> <46E24177.7070702@leemhuis.info> <46E2E099.9040402@s5r6.in-berlin.de>
In-Reply-To: <46E2E099.9040402@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.09.2007 19:49, Stefan Richter wrote:
> Thorsten Leemhuis wrote:
>> On 08.09.2007 01:38, Takashi Iwai wrote:
> [backports to -stable]
>>> Linux will suck really if one breaks so-called stable thing easily
>>> without actually testing.  For stable stuff, "it should be good" isn't
>>> enough.  It must be: "it IS good."
> This applies (or should apply...) to everything that goes to Linus in
> his pre -rc1 merge windows.  To post -rc1 submissions and even more so
> to -stable submissions, additional criteria apply.

Sure -- but new PCI-IDs for ATA-controller these days get added to
linus-tree post-rc1. They even find their way into the stable-tree since
some weeks now, and I think that's really good (due to one of those
patches my PATA-Controller in my 2 1/2 months old Laptop simply works
now and I don't have to wait until 2.6.23 is out).

But similar easy-and-small patches for the sound drivers (¹) take way
longer to get into the kernel.

(¹) -- like the patches I linked to earlier in this thread that add a
dmi-entry for another machine to the whitelist of machines to apply a
know workaround on. Or the regression for my laptop:
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a4eed138add1018846d17e813560b0c7c0ae8e01

> [...]
>> Linux IMHO will suck even more if crucial pieces of hardware does not
>> work for people easily, because Linux won't get even used then and will
>> frustrate people.
>>
>> Don't get me wrong; I understand and agree mostly to the points you
>> raised. But we nevertheless need to find a way to make todays hardware
>> usable more quickly, as that hardware is often on the market only for
>> some months or a year until the successor-model replaces it (which might
>> need new drivers or workarounds) --
> In the end there is but one solution to this:  Open specs.

Sure, I suppose most of us will agree on that.

But "open specs" is only part of the solution -- in and ideal world
users IMHO should have *easy* access to the proper drivers immediately
when the hardware becomes available. And that involves multiple layers IMHO:

1. hardware vendors need to open their specs before the hardware becomes
available (some like Intel for their ATA-Stuff do that afaics); hardware
also needs to be available for testing soon enough as well in case the
hardware-vendor is not the driver author at the same time (like in the
intel-case)

2. kernel developers need to have a workflow where at least small and
easy driver enhancements (e.g. those that just add a new PCI-IDs or
similar stuff like the extend list of machines to apply known workaround
on) make it quickly out into a officially released kernel. (Even bigger
driver updates IMHO need to get way quicker to the users, but that's a
more complex topic as there the risk of breaking something is bigger)

3. Distributors need to pick those kernels up and provide them to the
users. If they don't want to ship completely new kernels they need to
cherry-pick the improvements -- that's a lot of work and for the
distribution-kernel-maintainers if the maintainer of the driver in
question does not provide informations if a patch should be safe even
for older kernels; the interdependencies with other parts of the kernel
make it more complicated.

Point "3" is solved for me, as Fedora regularly ships new stable- and
linus-kernels during the life-time of a Fedora release (for other
distributions you are often out of luck and you have to use the
devel-tree, as only those get new kernels, but that's a different
discussion). But that doesn't help much if even a in-time
one-liner-pci-addition-patch from the vendor ("1") get stuck in area "2"
for weeks or months.

>> but it sometimes even for small
>> alsa-fixes takes as many months to make it from the developers out to
>> the kernel and from there to the distributions the user uses.
>>
>> It works better in some areas of the kernels (SATA and Network drivers
>> come to my mind) where patches make it quicker into the linus- and
>> stable-kernels -- in parts that is due to better cooperation with the
>> hardware-vendors, but it seems the sub-tree maintainers have a better
>> patch-/workflow, which has a strong impact as well.
> Feature additions to SATA and networking, e.g. support of additional
> hardware, are not backported to -stable or merged post -rc1 either, I
> presume. 

They are -- no many, but a few, and that's a good start IMHO:

=== linus

2.6.23-rc1 was on "22 Jul 2007"
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f695baf2df9e0413d3521661070103711545207a

The we had things like

Wed Aug 15 02:53:39 2007 -0400 sata_mv: PCI IDs for Hightpoint
RocketRaid 1740/1742
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cfbf723eb7928879292ee71fa0d118fc4e37b8c9

Wed Aug 22 14:28:02 2007 -0700 USB: resubmission unusual_devs
modification for Nikon D80
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=83fc8a151beda2d63e196a7ab2e12316c37a1e91

Fri Aug 31 03:48:49 2007 -0400 ata_piix: IDE mode SATA patch for Intel
Tolapai
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c5cf0ffa71d32c03607d287b76483479afb0bcd3

Fri Aug 31 04:00:19 2007 -0400 pata_marvell: Add more identifiers
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d36ee189f392ea89de85124a0b58477bb0f2e0a6

=== stable 2.6.22.y

Wed, 22 Aug 2007 23:23:26 +0000 (16:23 -0700) libata: add ATI SB700
device IDs to AHCI driver
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=commit;h=3443d563dc53875b15d919c4bece391f1ffd4776

Wed, 15 Aug 2007 16:25:10 +0000 (09:25 -0700) pata_atiixp: add SB700 PCI ID
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=commitdiff;h=fd2efeae63567dde934bb54772bb1b991275b04a

Thu, 9 Aug 2007 21:27:26 +0000 (14:27 -0700) Add a PCI ID for santa
rosa's PATA controller.
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=commit;h=a03cf181b9c19b4e95d847cd394c7ffaf5109d06

> Maybe they are better in getting stuff ready in time before
> merge windows open --- I don't know, I don't watch these subsystems.

Well, hardware gets quickly from development over production info the
marked and we IMHO need to be quickly as well if we want to support
todays hardware and not only yesterdays.

> Maybe they have less trouble with closed or nonexisting specs...?

Hehe, I'd say you should consider yourself lucky for the OHCI-standard
in the FireWire space -- that makes sure you don't have to deal with
PCI-ID-additions. ;-) And workarounds for specific controllers seems to
be seldom in that area as well (but often needed for sound-drivers these
days; and I had wrongly thought HDA would put that to and end...)

CU
knurd
