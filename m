Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZHZE6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZHZE6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 00:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZHZE6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 00:58:21 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:51875 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZHZE6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 00:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ajDFFNuxKywJ9IcThYAG0fk1YMAN6EJs2d1eFp9M6omTbeeUWXMus3r1tgppMNqvU/
         yiNV/jxERWyHKJjBnKg8BK6c+NX/ntqtW975tsjnBCEpgCpqeEf7VCS4sBW4NZfN0/FN
         c1dYmY52iaUx0wtg8fvfS2xTmpu+p2RnHZDnk=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0908252056170.3218@localhost.localdomain>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
	 <4A941E8B.8080902@plzk.org>
	 <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
	 <4A94599F.9020508@plzk.org>
	 <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
	 <1251239637.26348.20.camel@gaiman.anholt.net>
	 <20090826015127.GA1402@zhen-devel.sh.intel.com>
	 <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>
	 <21d7e9970908252047g6db2fb2aj69280efa5eebe681@mail.gmail.com>
	 <alpine.LFD.2.01.0908252056170.3218@localhost.localdomain>
Date: Wed, 26 Aug 2009 14:58:21 +1000
Message-ID: <21d7e9970908252158q30d7e4fay587458b79cd0c36d@mail.gmail.com>
Subject: Re: Linux 2.6.31-rc7
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>,
       mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 2:13 PM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 26 Aug 2009, Dave Airlie wrote:
>> >
>> > If you actually detected things _right_, none of this would be an issue.
>> > But you don't. And you seem to have a really hard time even admitting
>> > that. You try to re-detect things, and you SCREW UP.
>>
>> This isn't anything to do with redetection, and in the Mac case there isn't
>> even a BIOS table that you can really rely on since Apple hard coded all
>> this stuff into their EFI and Mac OSX drivers.
>
> That's really my point.
>
> There _is_ one sort of detection you could do: look at the actual state of
> the graphics chip.
>
> In other words, exactly the case you mention: don't trust any BIOS tables
> (they may not exist, and they _are_ broken in many cases) or silly EFI
> information (I guarantee that any firmware info will eventually be buggy:
> EFI is in no way going to be magically less buggy than BIOS tables have
> been).
>
> So what's left? You can still look at how the chip was programmed. If it's
> driving the VGA port, you can be pretty sure that there's a monitor
> attached. Sure, there might be something _else_ attached too, and I'm not
> saying that you cannot try to probe other things, but right now it seems
> that KMS totally throws away a free - and fairly reliable - piece of
> information. And replaces it with very unreliable information that
> definitely doesn't work.
>
> I'm all for looking at many different places to find 'the truth', but I'm
> very unhappy with KMS looks into BIOS tables, decides that there's a LVDS
> panel attached (there isn't), and then disables the VGA port that drives
> the monitor.
>
> That doesn't help _anybody_. It just results in a black screen. And I
> guarantee that this happens on several pieces of hardware, and no, it's
> not all just "crap Apple and EFI". One of the pieces of hardware it
> happens on is an Intel-only machine. Intel hardware, Intel firmware, Intel
> motherboard, Intel _everything_. And yes, KMS decides to drive a
> nonexistent LVDS display, rather than the one that the BIOS correctly
> booted up with.
>
>> Just because the BIOS manages to light up an output in now way effects
>> whether the driver can do the same.
>
> .. but if the BIOS drives one output, that should be a damn big hint that
> you shouldn't then just randomly pick another one!
>
> It sure as hell is a bigger hint than the ones you're using right now.
> Which is kind of my point here. Why are you arguing against a known bug?
>
>> I'm not sure why the mac-mini hack hasn't been merged I asked for it a
>> few times,
>> I'd rather the proper solution was merged but that seems to not have
>> happened either.
>
> I want to repeat: it's not just Mac Mini.
>
>> You have two special cases here,
>> a) mac mini - apple hw, needs hacks to workaround the fact that they do
>> something nobody else does with the hw and then don't tell you about it
>> in the hw. the hack from userspace should have been ported to the kernel
>> but I keep not seeing it.
>
> The thing is, the BIOS _does_ report it to the hardware: you could just
> read the hardware registers.
>
> But no. Instead the Intel KMS code discards the hardware registers, and
> reads the BIOS tables instead, finds a LVDS entry there, and uses that -
> and disconnects the entry that _was_ driving the monitor.
>
> Really. Do you seriously believe that because you found some random tables
> in the BIOS memory, it's more reliable than "oh, the BIOS set the hardware
> up to drive the SVDO output"?
>
> That's what I find irritating. We _know_ BIOS tables are random crap. We
> _know_ they are way less reliable than just asking the hardware where it
> is. But KMS still trusts the VBT data more than the fact that the chip has
> been programmed to output DVI/SVDO output.
>
>> b) pre-production SDV hardware for a mobile chipset without LVDS, here's
>> both pieces you get to keep them. LVDS isn't detectable on any hw, the
>> sanity assumption so far are you have a mobile chipset you must have
>> LVDS, you have an ACPI lid button you might have LVDS.
>
> Again, you say that, but you have absolutely nothing to back it up with.
>
> Here's a counter-argument: we _know_ that it's not detectable whether
> there's an LVDS panel is attached or not. So what should we do? Should we
> turn off the VGA1 connection that we can see that the BIOS programmed, and
> set things up for LVDS instead?
>
> That's f*cking _stupid_. Go ahead and program the LVDS panel *too*, but
> don't turn off the SDVO (or whatever) output that was also active!
>
> And quite frankly, if the BIOS didn't turn on the panel, then maybe the
> kernel shouldn't either. At least not until it gets a "lid open" event. So
> even the "go ahead and program LVDS too" part is quite debatable.
>
> In other words: it would be a lot saner to just keep whatever output mode
> that the machine booted with. Then, change it ONLY IF YOU DETECT SOMETHING
> ACTUALLY CHANGING.

So most of your arguments are valid and someone at Intel should probably
investigate it.

Some points though:
1. I know what hw you have, you reported bugs against only Apple and SDVs,
via Fedora we track a lot more hw, and we haven't seen this issue reported
on any production PC hardware.

2. LVDS is enabled by the BIOS so we read back the hw, its turned on even
on your SDV. So yes we shouldn't shut off VGA, but reading back the hw
isn't reliable either.

3. Here's the thing, we do detect something has changed, we detect we no
longer have a monitor connected on the mac mini because the routing
for the DDC pins is insane and need special treatment in the driver. So maybe
we get kms started and we fail when X tries to start or the first time the user
sets a mode or probes the hw. We also would really like to know some
information about
the monitor you plugged in so we don't do anything stupid to it.

so yes I think do better at failing is what is needed, its still
failing but its more
user friendly fail.

Dave.
