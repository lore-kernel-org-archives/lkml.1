Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbYHFDeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbYHFDeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762966AbYHFDdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:33:41 -0400
Received: from usul.saidi.cx ([204.11.33.34]:50522 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761504AbYHFDdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:33:39 -0400
Message-ID: <48991B83.5030607@overt.org>
Date: Tue, 05 Aug 2008 20:33:23 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v2)
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net>
In-Reply-To: <20080805212416.GB21738@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> 
> rfkill-input (now) or userspace (someday) will take care of kicking the
> radio to RFKILL_STATE_UNBLOCKED when (1) issues an event that signals that
> radios don't have to remain blocked.  Maybe this is why you see the WLAN
> going on when you deactivate the radio kill switch?

It's all done behind the scenes I think (it's an ipw2200 device). There's
no rfkill integration from that driver.

> And rfkill-input will soon be enhanced to let the user configure it to do
> something different if he wants.  Your driver doesn't (and shouldn't)
> hardcode policy about it.

Ok, that makes things much easier for me :-) But it means that for now the
user will have to manually kick the device.

> 
> Thanks.  Please take note that rfkill will, right now, try to BLOCK all
> radios on suspend.  That will be changed soon (2.6.28 at the latest), and
> your driver will have to handle blocking radios on suspend directly if it is
> needed for toshibas.

Why is this necessary? Doesn't the radio power down as part of the suspend
process? How would I tell what the hardware is doing?

I'll update the diff when I can.

--phil
