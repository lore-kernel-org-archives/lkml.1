Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZHYAWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZHYAWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 20:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZHYAWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 20:22:21 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:36719 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbZHYAWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 20:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=J0qZt6Wl9ba1vLIrUACshviNKCCAEcvPSyI0sJQ834HPvRPOuasRFi2cbmjm6DmeG3
         D2cHn/9tw5M6YfuUYgZaQVLTysDZ2eDKpxqBoNwUYiAu+XbbUwtQEOGdSHQ9NBfNKvtV
         UcGw3/HXU8mL7NfMrIChw0tywp0A4c7ovP6q4=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matt Causey <matt.causey@gmail.com>
Subject: Re: serio / atkbd / PS/2 Strangeness with Serial port adapter
Date: Mon, 24 Aug 2009 17:22:16 -0700
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc7; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <ac71f2bb0908061315o1449e91dge1d5a63a2a4b986a@mail.gmail.com> <20090810090508.69E02526EC9@mailhub.coreip.homeip.net> <ac71f2bb0908241709i1afa2cedy62c3dc13982f4fb7@mail.gmail.com>
In-Reply-To: <ac71f2bb0908241709i1afa2cedy62c3dc13982f4fb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <20090825005413.0C676526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 August 2009 17:09:20 Matt Causey wrote:
> On Mon, Aug 10, 2009 at 1:34 AM, Dmitry
> Torokhov<dmitry.torokhov@gmail.com> wrote:
> 
> >> [  459.004227] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1,
> >> 12, timeout) [445118]
> >> [20171.684870] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 0,
> >> 1) [20162195]
> >>
> >> However - the atkbd driver does not pick the device up at all.
> >>
> >
> > Your device is steadely refusing to say that it is a keyboard - and so
> > atkbd driver does not bind to it.
> >
> >> So, I did find a workaround (which is NOT acceptable for this
> >> deployment).  Remember the PS/2 'wedge' I mentioned?  Well, it has an
> >> extra PS/2 port for your keyboard.  If I connect a PS/2 keyboard to
> >> that thing, suddenly my scanner starts working.
> >>
> >> We see some chatter from the controller driver, then one of these:
> >>
> >> [23811.805578] input: AT Translated Set 2 keyboard as
> >> /devices/platform/i8042/serio0/input/input6
> >>
> >
> > That happened because apparently the 'wedge' passes the inquirys to
> > the real keyboard and it answers propery.
> >
> > I think the "i8042.dumbkbd" kernel parameter will solve your issue.
> >
> > --
> > Dmitry
> >
> 
> That's great.  I think it's the only option that I did not try.  ;-)
> Works great!
> 
> In case it matters:
> 
> blah blah/ # dmesg | grep i8042
> [    0.000000] Kernel command line: initrd=ramdisk.gz
> video="vesafb:mtrr,ywrap,1024x768-32@85" i8042.dumbkbd
> BOOT_IMAGE=bzImage auto
> [   14.046511] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   14.046578] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   15.804210] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input2
> blah blah/ #
> 
> Looks like it just decides that there must be a keyboard there,
> whether or not there really is one.
> 
> Are there any downsides to using this kernel parameter?
> 

The kernel will not control LEDs on the keyboard nor will it be able
to control hardware autorepeat parameters (software autorepeat should
still work fine).

-- 
Dmitry
