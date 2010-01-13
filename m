Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680Ab0AMUBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab0AMUBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 15:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646Ab0AMUBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 15:01:04 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44597 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab0AMUBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 15:01:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QAaAYjLRh+HweILl2xOwTw7Y24s5RDpCSug65tmi6hH0CGAwZLmFlU9LaaE9NEWMvt
         h2ZMZ2Aj70t5SMQvKrNfRPrwCae/bKiJDBiE8QB3MKkVJHIjC8eP0wEezLdcE5qUDfzY
         Ak/5g84FNbngylkL8JffRLBTcIrzjyX/nDl68=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001131947340.17662@casper.infradead.org>
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com>
	 <1262797226-9593-2-git-send-email-jhovold@gmail.com>
	 <alpine.LFD.2.00.1001061710510.5372@casper.infradead.org>
	 <20100106180950.GD10442@localhost>
	 <alpine.LFD.2.00.1001061814360.5372@casper.infradead.org>
	 <20100106191234.GE10442@localhost> <4B458209.2030600@xenontk.org>
	 <alpine.LFD.2.00.1001121645570.9778@casper.infradead.org>
	 <20100112093454.57176b8c@jbarnes-piketon>
	 <alpine.LFD.2.00.1001131947340.17662@casper.infradead.org>
Date: Wed, 13 Jan 2010 15:01:00 -0500
Message-ID: <a728f9f91001131201k6ba53710jdf85c1e38a937901@mail.gmail.com>
Subject: Re: [PATCH] drm/kms: fix fbdev blanking regression
From: Alex Deucher <alexdeucher@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, David John <davidjon@xenontk.org>,
       Johan Hovold <jhovold@gmail.com>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 2:48 PM, James Simmons <jsimmons@infradead.org> wrote:
>
>> > > On 01/07/2010 12:42 AM, Johan Hovold wrote:
>> > > >> Yeap. The fix uncovered a bug in your driver. I haven't heard of
>> > > >> problems with the other drm drivers.
>> > > >>
>> > > >>> The backlight is handled via the DRI driver I assume. At least
>> > > >>> i9xx_crtc_dpms is called on powerdown.
>> > > >>
>> > > >> Can you post your dmesg and kernel config.
>> > >
>> > > [snip]
>> > >
>> > > Adding the Intel DRM people in CC as well. I have the same issue
>> > > with my GM45.
>> >
>> > Okay I looked at the code to figure out what is happening and why
>> > only this driver has problems. The problem is that the framebuffer
>> > layer expects the backlight to be a seperate device. The reason being
>> > is that some embedded systems will use a gpio backlight. That way
>> > power management for a graphics card/backlight has 3 seperate states.
>> > Currently the intel DRM driver treats the backlight as being apart of
>> > the encoder. Jesse do you have objections to having the intel driver
>> > expose a backlight device. The bonus of that is the user can also set
>> > the backlight levels.
>>
>> On Intel we usually expect the backlight to be exposed by ACPI or a
>> platform driver.  On recent platforms, the ACPI driver will actually
>> send requests to the gfx driver to do the actual register writes to
>> adjust the backlight, but it's still ACPI driven.
>>
>> Maybe we just need to wire up the fb backlight hooks appropriately?
>
> Yeap. I can have patch ready for you this weekend. I lack the hardware to
> test it tho. Never been able to find a intel pci card that is not built
> into the motherboard.

They don't exist, other than the old i740s.

Alex
