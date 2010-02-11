Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0BKRNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:13:07 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:40131 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750804Ab0BKRNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:13:05 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [Q] i2c-taos-evm bus driver
Date: Thu, 11 Feb 2010 12:12:51 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902153420@mi8nycmail19.Mi8.com>
In-Reply-To: <20100209214252.2a01f010@hyperion.delvare>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Q] i2c-taos-evm bus driver
Thread-Index: AcqpyHVS3SRdILySQjex3bSl9D+LkABc53kg
References: <BD79186B4FD85F4B8E60E381CAEE190902152F0E@mi8nycmail19.Mi8.com><20100209091639.5b6e39a5@hyperion.delvare><BD79186B4FD85F4B8E60E381CAEE190902152FBE@mi8nycmail19.Mi8.com> <20100209214252.2a01f010@hyperion.delvare>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: <linux-kernel@vger.kernel.org>, "Linux I2C" <linux-i2c@vger.kernel.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
X-OriginalArrivalTime: 11 Feb 2010 17:12:59.0401 (UTC) FILETIME=[75F7CF90:01CAAB3D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 09, 2010 1:43 PM, Jean Delvare wrote:
> Hi Hartley,

Hello.

> On Tue, 9 Feb 2010 11:38:37 -0500, H Hartley Sweeten wrote:
>> On Tuesday, February 09, 2010 1:17 AM, Jean Delvare wrote:
>>> No, it works reasonably fine. I was using it myself no later than one
>>> month ago. Out of curiosity, with which exact evaluation module do you
>>> plan to use it?
>> 
>> I'm not actually...
>> 
>> I am trying to figure out how a serio driver actually gets "hooked" to a
>> serial port.  The i2c-taos-evm driver looked simple enough to play with
>> in order to figure it out.  I was trying to follow the Documentation in
>> order to use it and ran into the issue below.
>
> OK... but please keep in mind that you won't be able to use this driver
> without supported hardware. The driver will not bind to the serial port
> if it doesn't detect a supported device.

That's what I am trying to figure out.

Now that I know the baud rate and port setting from your patch to inputattach.c
I was just going to dummy something up to one of my serial ports.  I really
don't need the i2c-taos-evm driver to "work" I just want to figure out how
the serio connection is made.

It still seems strange to me that a user space application is needed to connect
two kernel drivers together.  Actually three if you include the serio "bridge".
I assume the actual connection between the drivers is something like this:

	some_tty_driver <--> serio <--> i2c-taos-evm

>> (...)
>> Do you know if there is a way to make the connection in kernel?

> I suppose this is possible from a pure code perspective, but I can't
> see why one would want to do that. The kernel has no idea what is
> connected to the serial ports: devices on the serial port can't be
> reliably nor safely probed. This is why we rely on user-space to
> declare which device is connected to which port, based on the
> assumption that the user knows what he or she is doing.

My intention is to do this in an embedded system.  The serial port
I am using will always be connected to the target device.  I am just
Trying to figure out a way to make the kernel driver connection.

>> Also, do you know if there is any information on the serio stuff
>> available anywhere?  Other than just reading the kernel source I
>> have not been able to locate anything.
>
> I seem to remember I hit the exact same problem back when I wrote the
> i2c-taos-evm driver. I ended up reading the source code of other serial
> device drivers and used them as an example. It was enough to get things
> to work, but I won't claim I understood all of serio... just enough to
> do what I needed back then.
>
> Maybe Dmitry Torokhov (Cc'd) will be more helpful than me.

Hopefully... There seems to be a real lack of information available.

Thanks for the reply,
Hartley
