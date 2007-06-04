Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbXFDWqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbXFDWqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbXFDWqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:46:30 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:58725 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbXFDWq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TUhJjmdlByWsZhGjKpQGUz38/wGirEeyiS4NUa+CaqqbkCnGzpE5eVfMZ4vzO9rEvBiLhZ8MDDtTwXk1I6vpcrXLuofhbjYvMe/dPWbXUwmjnA8oEG8A6wO5baOSofcm/GLE1RKKApLi+71sVk8nOX9w8IfZbvQ9b+bs8TXQ1c0=
Message-ID: <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com>
Date: Mon, 4 Jun 2007 23:46:28 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz>
	 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com>
	 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
	 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
	 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
	 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com>
	 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
	 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com>
	 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/07, Jiri Kosina <jkosina@suse.cz> wrote:
> sorry, don't fully understand - what do you mean by "got the messages but
> not the fix"?

The range "detected" was 0 to 255 but both X and Y axis are reporting 4096.

I think that the code in drivers/hid/hid-input.c:
if ((device->quirks & HID_QUIRK_BADPAD) && (usage->code == ABS_X ||
usage->code == ABS_Y)) {
  a = field->logical_minimum = 0;
  b = field->logical_maximum = 255;
}

should get what's being reported from the device instead of hard-code
to 0 to 255 (which might not even be an unsigned range).


> Well calibration using jscal might be needed, that should be fine. The
> question is whether the ranges are now correct and calibration using jscal
> works fine.

Ok, so maybe in that case my automatic calibration is still worth to
put on joydev.c
and users from all joysticks in the quirk list would benefit.


> So please let me know whether the badpad quirk is the correct one for this
> joystick. If so, I'll queue it in my tree for upstream.

Well, it did the trick if that's what you mean but would be better to
get the correct range from start... But I don't know how difficult it
is, so maybe we'll have to stick with the automatic calibration
afterwards...

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
