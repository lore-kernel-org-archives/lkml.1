Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970Ab0AVWdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0AVWdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 17:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645Ab0AVWdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 17:33:01 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:36736 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab0AVWdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 17:33:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w7+EplyRu3//XNL1X7gqVJdW1wV0O4FF0brO7bKNchCJL59pjldIYDHFrP3evwGdP1
         pHSzOLBeopI6XDQKr4ea4tCMJD2rbLY5bxJdfhH70fJ1UsVyqS4+G6ybY3ufU661518b
         lYTDi6Tynmo9IcC3SpVwpw96ihANPZae7bQSc=
MIME-Version: 1.0
In-Reply-To: <4B59E47D.8010702@zytor.com>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B57A2D4.9030204@gmail.com>
	 <20100121185544.GB11996@core.coreip.homeip.net>
	 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
	 <20100121221701.GA15293@core.coreip.homeip.net>
	 <51f3faa71001211626y1e65f81ambfa4ad19af5aa5ff@mail.gmail.com>
	 <4B59E47D.8010702@zytor.com>
Date: Fri, 22 Jan 2010 16:33:00 -0600
Message-ID: <51f3faa71001221433k72f20addg48e0735fe1b032d@mail.gmail.com>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Robert Hancock <hancockrwd@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com,
       vojtech@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 11:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/21/2010 04:26 PM, Robert Hancock wrote:
>>>
>>> This is from the changelog when this was introduced:
>>>
>>> -------------------------------------------------------------------------
>>> 2005/02/25 21:21:03+01:00 vojtech
>>> input: After testing on real world hardware, it's obvious we can't trust
>>>       ACPIPnP nor PnPBIOS to properly report the existence of a keyboard
>>>       and mouse port in all cases. Some BIOSes hide the ports if no mouse
>>>       or keyboard is connected, causing trouble with eg. KVM switches.
>>
>> If it's just that case (which isn't certain given Vojtech's report),
>> then I think it's reasonable to ignore that by default. If the BIOS
>> decided to hide the controller then our default behavior should be to
>> believe it, with the ability to override that if necessary, not the
>> other way around.
>>
>
> You think it's reasonable to have the keyboard not work because
> someone's KVM switch was in the wrong position when the system booted?
> Sorry, that's not how the world works.  It's sad that someone had the
> bright idea that things should work that way, but that is definitely a
> regression I wouldn't want to deal with.

I don't imagine most KVM switches would result in this - they usually
emulate the presence of a keyboard and mouse on all ports even if the
input isn't the active one. It could be the reporter had an older
switch that didn't do this.

I expect that it's quite common for the BIOS to disable the controller
if no device is detected, though. I think the idea is to prevent a
useless device from showing up in Device Manager and free up resources
for other devices. Problem is if it does this, we don't really know
what it did other than remove the PNP entry, and whether using the
controller anyway will work safely.

In any case, it's unlikely (though I admit I'm uncertain) that Windows
is going to blindly probe for an 8042 controller if the PNP
information doesn't indicate that one should be there - at least not
if it's using the ACPI HAL. And for this sort of hardware
compatibility issue, doing things differently than Windows does is
ultimately asking for trouble in the long term. It's highly
unreasonable to break that just for an unlikely corner case.

>
> The only thing that I could think of as a reasonable limit would be to
> not probe these ports if we are booted from EFI/UEFI.  That would cover
> the ia64 case, too.  However, I'm hardly confident that we wouldn't have
> the same class of problems even there.
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
>
