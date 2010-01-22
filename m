Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051Ab0AVRrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab0AVRrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043Ab0AVRrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:47:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52683 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab0AVRrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:47:02 -0500
Message-ID: <4B59E47D.8010702@zytor.com>
Date: Fri, 22 Jan 2010 09:46:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com,
       vojtech@suse.cz
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
References: <1264011793.1735.3683.camel@localhost.localdomain>	 <4B57A2D4.9030204@gmail.com>	 <20100121185544.GB11996@core.coreip.homeip.net>	 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>	 <20100121221701.GA15293@core.coreip.homeip.net> <51f3faa71001211626y1e65f81ambfa4ad19af5aa5ff@mail.gmail.com>
In-Reply-To: <51f3faa71001211626y1e65f81ambfa4ad19af5aa5ff@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 04:26 PM, Robert Hancock wrote:
>>
>> This is from the changelog when this was introduced:
>>
>> -------------------------------------------------------------------------
>> 2005/02/25 21:21:03+01:00 vojtech
>> input: After testing on real world hardware, it's obvious we can't trust
>>       ACPIPnP nor PnPBIOS to properly report the existence of a keyboard
>>       and mouse port in all cases. Some BIOSes hide the ports if no mouse
>>       or keyboard is connected, causing trouble with eg. KVM switches.
> 
> If it's just that case (which isn't certain given Vojtech's report),
> then I think it's reasonable to ignore that by default. If the BIOS
> decided to hide the controller then our default behavior should be to
> believe it, with the ability to override that if necessary, not the
> other way around.
> 

You think it's reasonable to have the keyboard not work because
someone's KVM switch was in the wrong position when the system booted?
Sorry, that's not how the world works.  It's sad that someone had the
bright idea that things should work that way, but that is definitely a
regression I wouldn't want to deal with.

The only thing that I could think of as a reasonable limit would be to
not probe these ports if we are booted from EFI/UEFI.  That would cover
the ia64 case, too.  However, I'm hardly confident that we wouldn't have
the same class of problems even there.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

