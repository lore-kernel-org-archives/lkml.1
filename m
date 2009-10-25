Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZJYTH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZJYTH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZJYTH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:07:28 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:62282 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZJYTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XcemHeNHVmUJsbpM4G+8dvZMJJdANSioC2RO1fMhchvWTtnZd8eyzhXiDmvFUi8mxR
         s3UJgLHogjuM8iz7b4aHG2Ox2CPDl6tfSJLpevskHX1wzI3NqN0B7vPKvCuigxEcU4mP
         3QliVZLmlzhoQoU07/bvmhlYAkHC2bNVz5PXQ=
Date: Sun, 25 Oct 2009 12:07:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not  work
	anymore
Message-ID: <20091025190726.GA20932@core.coreip.homeip.net>
References: <200910211320.16339.dmitry.torokhov@gmail.com> <4AE0840C.8070801@tremplin-utc.net> <20091022162202.GA18031@core.coreip.homeip.net> <4AE09AFF.805@tremplin-utc.net> <20091022181915.GB18031@core.coreip.homeip.net> <4AE16489.4030008@tremplin-utc.net> <20091023085824.GA7199@core.coreip.homeip.net> <4AE17586.9020009@tremplin-utc.net> <20091023163113.GA7707@core.coreip.homeip.net> <4AE43AB7.8070601@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AE43AB7.8070601@tremplin-utc.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 12:47:03PM +0100, Éric Piel wrote:
> Op 23-10-09 18:31, Dmitry Torokhov schreef:
>>
>> Right, your init scripts/UDEV/HAL whatever adjust keymap to match your
>> laptop.
> :
>> Now, all depends on when this adjustment happens... In your case it
>> looks like X server starts before the keymap is adjusted, so on first
>> resume the keymaps are different and it disables the device.
> Ok, now I catch it. It's actually my own written script, which is  
> executed at init a bit after X starts. It does a couple of  
> "setkeycodes". So now the scenario is very clear: X starts, init script  
> do setkeycodes, resume/suspend, X detect a difference in keymaps and  
> disable the device.

Yep.

OK, so X's evdev is still too paranoid but now we know the whole picture
and for my part I declare kernel is free from blame ;)

>
> BTW, I haven't really found info about this: what does setkeycodes? It  
> does not work on a specific device, but still it changes keymap of some  
> specific devices. Does it change only the current devices which have  
> keys?

setkeycodes issues KDSETKEYCODE which goes through all devices bound to
the "kbd" input handler and sets keycode for the specified scan code for
all devices that support that scancode.

> Whenever a new input device appears, all the setkeycodes should be  
> re-executed?
>

It is recommended to adjust individual devices and HAL has facilities to
do that (although now that they deprecating HAL I am not sure what the
replacement is). Anyway, for HAL look into:

	/usr/share/hal/fdi/information/10freedesktop/*-keymap-*.fdi

The nice thing here is that keymaps are re-applied if device gets
disconnected and rediscovered for one reason or another.

-- 
Dmitry
