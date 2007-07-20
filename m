Return-Path: <linux-kernel-owner+w=401wt.eu-S935584AbXGTRrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935584AbXGTRrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756491AbXGTRrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:47:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:12161 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbXGTRrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O+SbDYC0HQonuF9sqUSsAlmRxsFdZ3qQIwEqY++prk3kNKhCtJIw4uYNJShiqrTl3oeQpC0as+yfR+rSUCwXfoOcxMTQI5AM2Rzov6WBNdRoeYeO3kaV4rZbUYwLFZcyMcukrozAj+GrVSpc1wLXw5L7LRR1AiUgyTHlUjPkRGU=
Message-ID: <d120d5000707201047y2d22167co882a10176d79fce4@mail.gmail.com>
Date: Fri, 20 Jul 2007 13:47:36 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Subject: Re: [patch 1/3] m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20070720164323.625963918@mail.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720164043.523003359@mail.of.borg>
	 <20070720164323.625963918@mail.of.borg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 7/20/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
>
> m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
>
> drivers/char/keyboard.c: In function 'kbd_keycode':
> drivers/char/keyboard.c:1142: error: implicit declaration of function 'mac_hid_mouse_emulate_buttons'
>
> The forward declaration of mac_hid_mouse_emulate_buttons() is not visible on
> m68k because it's hidden in the middle of a big #ifdef block.
>
> Move it to <linux/hid.h>, correct the type of the second parameter, and
> include <linux/hid.h> where needed.

linux/hid.h contains definitions needed for drivers speaking HID
protocol, I don't think we want to put quirks for legacy keyboard
driver there. I'd just move the #ifdef within drivers/char/keyboard.c
for now.

BTW, I don't think that mac button emulation will work well when x86
evdev-based driver gains popularity - it "grabs" the device and so no
event will flow through keyboard driver... We'd need a new solution...

-- 
Dmitry
