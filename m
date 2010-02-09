Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0BIUm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:42:57 -0500
Received: from bamako.nerim.net ([62.4.17.28]:60625 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0BIUmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:42:55 -0500
Date: Tue, 9 Feb 2010 21:42:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: <linux-kernel@vger.kernel.org>, "Linux I2C" <linux-i2c@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [Q] i2c-taos-evm bus driver
Message-ID: <20100209214252.2a01f010@hyperion.delvare>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902152FBE@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190902152F0E@mi8nycmail19.Mi8.com>
	<20100209091639.5b6e39a5@hyperion.delvare>
	<BD79186B4FD85F4B8E60E381CAEE190902152FBE@mi8nycmail19.Mi8.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hartley,

On Tue, 9 Feb 2010 11:38:37 -0500, H Hartley Sweeten wrote:
> On Tuesday, February 09, 2010 1:17 AM, Jean Delvare wrote:
> > No, it works reasonably fine. I was using it myself no later than one
> > month ago. Out of curiosity, with which exact evaluation module do you
> > plan to use it?
> 
> I'm not actually...
> 
> I am trying to figure out how a serio driver actually gets "hooked" to a
> serial port.  The i2c-taos-evm driver looked simple enough to play with
> in order to figure it out.  I was trying to follow the Documentation in
> order to use it and ran into the issue below.

OK... but please keep in mind that you won't be able to use this driver
without supported hardware. The driver will not bind to the serial port
if it doesn't detect a supported device.

> (...)
> Do you know if there is a way to make the connection in kernel?

I suppose this is possible from a pure code perspective, but I can't
see why one would want to do that. The kernel has no idea what is
connected to the serial ports: devices on the serial port can't be
reliably nor safely probed. This is why we rely on user-space to
declare which device is connected to which port, based on the
assumption that the user knows what he or she is doing.

> Also, do you know if there is any information on the serio stuff
> available anywhere?  Other than just reading the kernel source I
> have not been able to locate anything.

I seem to remember I hit the exact same problem back when I wrote the
i2c-taos-evm driver. I ended up reading the source code of other serial
device drivers and used them as an example. It was enough to get things
to work, but I won't claim I understood all of serio... just enough to
do what I needed back then.

Maybe Dmitry Torokhov (Cc'd) will be more helpful than me.

-- 
Jean Delvare
