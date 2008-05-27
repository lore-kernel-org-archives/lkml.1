Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbYE0Mxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbYE0Mxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 08:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYE0Mxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 08:53:33 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:28113 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbYE0MxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 08:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=VooyXGJ4Jb9/c4KZNgpMXTuWLgHHX4Mkd3GS/HBSC+c2bykRiZsQu+ovnbhXVqbXLqANToj2xmUosrPdK7xbkklPHBZyRAh+DDQQ32lQodYmAtslivteZygerZNTg9wnMCEvlBdRjVDnNsmHE11+/PtaxP611Pr0hTJIGmmFyV8=
Date: Tue, 27 May 2008 08:53:13 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: N?stor Amigo Cairo <nestorac@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: QUESTION: How can I make a driver for a special serial
	keyboard which also supports output (maybe via serio_raw)?
Message-ID: <20080527084431.ZZRA012@mailhub.coreip.homeip.net>
References: <b321594e0805250952q18465dc2h8af60aa25143693d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b321594e0805250952q18465dc2h8af60aa25143693d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 25, 2008 at 06:52:26PM +0200, N?stor Amigo Cairo wrote:
> Hello!
> 
> I'm trying to make a driver for a special keyboard with just three keys, for
> an embedded application. This really is a PIC attached to a serial interface
> which sends some bytes to the computer to manage an application, and then
> receives some others to control an embedded device using the same cable. So
> there's a two way connection between them.
> For now, I have been able to customize the newtonkbd driver to adapt it to
> receive some bytes and translate them to keys, but I'm not able to send any
> data. /dev/ttyS0 gets blocked when setting up the driver with a customized
> version of `inputattach`, an application which ioctl's the serial device to
> the driver. Write() does not work, since it's not implemented in the driver.
> Is there any way of implementing access to this device using the same
> Write() calls as in other apps?
> Or is there any other way of doing it?? Some documentation??
> 

You would need to implement ->event() handler in your 'keyboard' that
would call serio->write() on the underlying serio port. Then, by
opening /dev/input/eventX and writing into it you can send input
events back to the device.

Although I wonder if your device really useable as a generic
keyboard/button device. You may be better off just using the serial
port from the userspace.

-- 
Dmitry
