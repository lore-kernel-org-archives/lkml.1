Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbXFUJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbXFUJdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 05:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbXFUJdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 05:33:05 -0400
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:2082 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757112AbXFUJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 05:33:03 -0400
Date: Thu, 21 Jun 2007 11:33:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Vojtech Pavlik <vojtech@ucw.cz>
Subject: Re: Writing a driver for a legacy serial device
Message-ID: <20070621113358.1d65678d@hyperion.delvare>
In-Reply-To: <200706202311.33326.dtor@insightbb.com>
References: <20070619190502.05d4e0c8@hyperion.delvare>
	<d120d5000706191159w29ebd0dajbd6cb9ac78d4faa2@mail.gmail.com>
	<20070620105648.6d18ad66@hyperion.delvare>
	<200706202311.33326.dtor@insightbb.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, 20 Jun 2007 23:11:32 -0400, Dmitry Torokhov wrote:
> On Wednesday 20 June 2007 04:56, Jean Delvare wrote:
> > Ah, I see. There's no way to detect what device is connected to the
> > serial port, so we need a user-space tool to bind the port to the right
> > driver? Makes some sense, even though it's a but strange that I need
> > something called inputattach for a device which isn't an input device.
> 
> Because serio interface is mostly used with input devices. For all other
> devices I think universal answer is "userspace" but with input devices
> we want to do processing in kernel so we can route events into console
> and other standard interfaces (although one coudl use uinput to achieve
> similar result).

OK. This leads me to a question: is it OK for me to add support for my
non-input device to inputattach, or is a separate, dedicated helper
tool preferred? Both ways are fine with me, I don't know what the input
subsystem maintainers expect.

> > But unfortunately, my driver's .connect function is still not called.
> > I guess that I missed one step? Any idea what it would be?
> 
> Not sure. Could you check /sys/bus/serio/devices/serioX/id/* and verify
> that inputattach sets up serio port properly?

Thanks for the hint, I checked that and the proto value was 42 instead
of the expected 40. Reading the source code of my local copy of
inputattach.c, I found that SERIO_RS232 was OR'd to the value. This
seems to be a rather old bug which is already fixed upstream:

http://linuxconsole.cvs.sourceforge.net/linuxconsole/ruby/utils/inputattach.c?r1=1.23&r2=1.24

But for some reason the openSuse package is lagging behind. I'll go
update it.

After fixing this, I finally see my .connect function being called! Now
I can start doing the real driver development work. Thanks a lot for
your highly valuable help, Dmitry :)

-- 
Jean Delvare
