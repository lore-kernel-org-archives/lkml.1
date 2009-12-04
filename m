Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbZLDNk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbZLDNk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932138AbZLDNkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:40:55 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40336 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbZLDNky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:40:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=B2QfdnV2xDiGwoP+6FvKdJAKGFtmsamLUU+AW7P26a7ZIRlBUDFk57SXd1mcCTR5tM
         QZH9IDrHeVqnxMKt4XveKqmaW1JTGZmHWne54iy0QxTl43r/79bql+p8vPyb926TTcNa
         C993UCohiSUZLTDXd5+I7IVCwbxBEPvn9pDks=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Peter Hutterer <peter.hutterer@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>
	<87zl60s17o.fsf@macbook.be.48ers.dk> <4B1836A6.405@redhat.com>
	<871vjasxnm.fsf@macbook.be.48ers.dk> <4B190D88.4090102@redhat.com>
Date: Fri, 04 Dec 2009 14:40:56 +0100
In-Reply-To: <4B190D88.4090102@redhat.com> (Peter Hutterer's message of "Fri,
	04 Dec 2009 23:24:24 +1000")
Message-ID: <87ws12rh5j.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Peter" == Peter Hutterer <peter.hutterer@redhat.com> writes:

Hi,

 Peter> with the quirk, the device exposes three /dev/input/event files, the
 Peter> highest of which sends the actual events now (in X/Y). number two
 Peter> looks like a mouse device (like yours), number three like a
 Peter> touchscreen (BTN_TOUCH, etc.)
 Peter> without the quirk, I only get two devices, the second of which looks
 Peter> like a mix of mouse/touchscreen and it sends ABS_Z/ABS_RX while ABS_X
 Peter> and ABS_Y are mute. I can get you the full evtest blurb but not before
 Peter> Monday, the screen is in the office.

Ahh ok, strange that I'm not seing the same as you. The reason why
there's two devices by default is that the NW pretends to be a keyboard
with numlock/scrolllock/caplock so it can go into calibration mode if
you press the button a number of times (by default 6).

 Peter> where do I get nwtool from? google is unusually quiet about it.

I guess I need more google-foo ;) It's a tool I wrote:

http://git.korsgaard.com/cgi-bin/gitweb.cgi?p=nwtool.git;a=summary

You can git clone from http://git.korsgaard.com/git/nwtool.git

Nextwindow unfortunately never documented the really interesting
commands (like how to make settings persistent), so it cannot do
everything the Windows tool can.

 Peter> is it possible that you changed the report mode (or have it different
 Peter> to me anyway) and that affects things?

Not that I'm aware - I just plugged the device in seconds before running
evtest.

FYI, now that we're talking about NW touchscreens - How is multiscreen
setups with evdev supposed to work? We need something to bind a
touchscreen to an Xrandr output to translate (and with 1.3+ reverse
transform) the coordinates. In the old days you could use evtouch with
seperate X screens and bind the touchscreens to each screen.

It's probably offtopic here, but we can move the discussion to the X
list if you prefer - Last time I asked there I didn't get any reply
though:

http://article.gmane.org/gmane.comp.freedesktop.xorg/40071/

-- 
Bye, Peter Korsgaard
