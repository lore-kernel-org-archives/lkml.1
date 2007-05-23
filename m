Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbXEWXK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbXEWXK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbXEWXKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:10:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:37442 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbXEWXKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HCHtc92MJkECyuPJkkwtIrTfHuErEk1u7Q6AIHrgkqPXR9JZs6+5R8vJFWkkCKsCGMrv8WfLJwNkE8fM0uyomIKESGbd37mH8zOrv1yxkSKK99lGlGgY9QXN17AtaL4VQpVMG/vQZI/P3Aelj5w4O+6qXXnwYRfAoDMzlWOaVb0=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jindrich Makovicka <makovick@gmail.com>
Subject: Re: Enabling power states for Core 2 Duo
Date: Thu, 24 May 2007 02:09:02 +0300
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org
References: <8aa016e10705220937t6cfbacbj4fe8fc97d135924@mail.gmail.com> <BAY20-F1412F1EDFF34450CE1F213F9360@phx.gbl> <20070522193519.53f0021e@holly>
In-Reply-To: <20070522193519.53f0021e@holly>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705240209.03198.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 May 2007 20:35, Jindrich Makovicka wrote:
> On Tue, 22 May 2007 17:14:45 +0000
>
> "Paa Paa" <paapaa125@hotmail.com> wrote:
> > >>But are you saying that with most desktop mobos one doesn't usually
> > >>have the
> > >>different power states available at all? So basically the only
> > >>means to conserve power is to scale the frequency?
> > >
> > >Please update your BIOS and try.
> >
> > I updated my Asus P5B Deluxe BIOS with no luck (this latest BIOS is
> > about 1 month old). Still no power states. I would be nice to know if
> > _any_ desktop C2D mobos have these C-states? (In x86_64 system).
> >
> > I think I never mentioned:
> >
> > I'm using 2.6.21.1 (actually gentoo-sources-2.6.21-r1)
> > My CPU is E6400.
>
> I observe the same problem with Gigabyte 965P-DS4, and there are at
> least two causes - 1) MP supported flag in FADT is missing (so
> CPU_HOTPLUG would be necessary), and 2) C2 latency is set to 101,
> while the maximum allowed in the kernel is 100.
>
> However, from the power consumption and the CPU temperature it seems
> that the power saving works anyway, so I'll live with it.

Hi,

I also don't have C-states on my DG965RY intel board with core 2 duo E6400

Any board can support C-states ether by fixed ACPI set of registers or by a 
set of functions in acpi tables.

On my system ICH8 (and I almost sure you got it too), doesn't support 
fixed-function C-states.

And there is no other magic chip that can put cpu in c-state (on my system) , 
so acpi has no "set of functions to do that"

So I guess that on my board there is no physical support for C-states, and 
this could be true for you too.

Anyway monitor/mwait can put cpu in C1, and having apic-stops-in-c2/c3 bug,
I don't think those states are that needed.

The Speedstep support is a different thing at all:
Agian acpi has a function that can change cpu clock speed to fixed values,
And yes on my board it also has only two values: 1500 and 2130.
This support is implemented by accessing the clock chip
(Actualy on my system acpi writes a magic value to one of ICH8 registers, and 
this triggers a SMM that changes the clock)

And the last thing is about throtting states your and mine system does 
support:
Throttling states are states that make system halt cpu for some % of time,
Yes there are 8 such states. You can enter one of those by writeing a state 
number to /proc/acpi/processor/*/throttling (I assume you have ICH8 or 
someting simular)
Also ICH*'s throtting states are system global, this is why I wrote "/*/"
If you change it for one core, it will be changed for other.
They are supported by fixed acpi function (by ICH8)

My 2 cents.

Regards
	Maxim Levitsky
