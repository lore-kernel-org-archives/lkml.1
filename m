Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbZCaWTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbZCaWTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbZCaWTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:19:32 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:43786 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbZCaWTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mw0VM7c1pxcKmpdiwjvgulJRw3HxkfDF0EYlh6Exx9txitfyL6uoKRnX7StuWDuAa9
         NgDTnmV5udCy9C4NWcG2RTObyaQ6ud/ptCeSIUpnoYZft8TCnkEpTH/FW5F6LU9nco96
         sOOPNnAo9ZhZcwiOP6iPsyBi1voFj8BmwPFBw=
MIME-Version: 1.0
In-Reply-To: <20090331221107.GA30383@srcf.ucam.org>
References: <20090331214501.GC29489@srcf.ucam.org>
	 <20090331214749.GD29489@srcf.ucam.org>
	 <74962ea30903311506m41306659td0cd70c5736f6660@mail.gmail.com>
	 <20090331221107.GA30383@srcf.ucam.org>
Date: Wed, 1 Apr 2009 15:19:28 +1700
Message-ID: <74962ea30903311519s2fb6087fxfe8859e3c570ac99@mail.gmail.com>
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org, lenb@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 3:11 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Apr 01, 2009 at 03:06:12PM +1700, Azael Avalos wrote:
>
>> Indeed, my Satellite X205-9800 uses that method, however, it only provides
>> HCI call 0x001E (Hotkey Events) and no System Event FIFO (0x0016),
>> instead, hotkeys are entered on a variable called TOHK (TOshiba HotKeys?).
>> Located in my model in
>>
>> PCI0.LPCB.EC0.TOHK
>
> Ok, interesting. Looking at the DSDTs I have here, TOHK isn't always
> present on TOS1900 devices. However:
>
>> and it appears that it can be _polled_ tru' method INFO
>> (TOSH_INTERFACE_2 ".INFO"),
>> perhaps a small change in the polling to reflect to that method for
>> TOS1900 devices would be necessary.
>
> The INFO method is, so this looks like a good call.
>
>>
>> On my model the complete call would be:
>>
>> \\_SB.VALZ.SPFC
>> \\_SB.VALZ.INFO
>>
>> Is it different from \\_SB_.VALZ.SPFC or it simply doesn't matter?
>
> Yeah, that shouldn't matter. So it simply looks like in the notification
> function on these systems we should call the INFO method and that'll
> give us the key back? I'll send a test patch later (don't have any
> hardware to test right now).

Well, on my model after enabling Hotkey Events, Fn-Fx events are entered
to that variable according to Toshiba, eg.: Fn-Esc would give me 0x101, etc.

I'm at work right now, and will be in the next 2 hours, when I get
home I'll test
whatever patch you send.

By the way, you can find a copy of my DSDT here:

http://cig.uacj.mx/~azael/Toshiba/Satellite_X205-S9800.dsl

>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

Saludos
Azael



-- 
-- El mundo apesta y vosotros apestais tambien --
