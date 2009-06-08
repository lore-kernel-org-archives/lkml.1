Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbZFHGgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbZFHGgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZFHGgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:36:36 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:64913 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZFHGgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=puUZed/TR7jl1+2CvdqCpC0SNMS/XnvrQpCQYdemMkzUY6aPUxsKeg3eTvsKuE5fhu
         u1KWqqlUkQVjw0pilFD+3wbkpDwcOdkO5EF7uc278Zr5XNvRvHR6HH+/JNjvpWMm7MUg
         72eLqVjOHe+aqcpbS+qbb10EGK7RMiekYKmIg=
MIME-Version: 1.0
In-Reply-To: <20090607224519.GO2014@woodchuck>
References: <20090607224519.GO2014@woodchuck>
Date: Mon, 8 Jun 2009 08:36:36 +0200
X-Google-Sender-Auth: cd4037e1747bad6d
Message-ID: <10f740e80906072336n5e7b3d4te5834ff89b277bd0@mail.gmail.com>
Subject: Re: driver model advice
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 00:45, Alexander Clouter<alex@digriz.org.uk> wrote:
> For a while I have been maintaining the TS-7800 mainline support[1] and
> decided to attempt to properly address support for the FPGA on the
> board.
>
> Currently the solution I'm using[2] is not very flexible and scalable as
> for every device that is added the platform code grows with it.  I also
> think it's just not very pretty.
>
> I have been reading various sources of documentation regarding the
> driver model and relevant sections in the LDD tomb and felt that making
> the FPGA behave as a bus seemed a neat way to do things.
>
> A quick overview of the approach I'm using is that the bus code adds and
> removes the devices depending on the bus's state ('online' or
> 'offline').  When going online (or as new drivers are insmod'ed) the bus
> decides if the 'discover' function should be executed depending on the
> FPGA bitstream magic number and then if the driver's discover() function
> decides the device is present it is added to the bus.

You can make it a separate bus...

> The code for my amendments can be found (it's 30kB hence why it's not
> inline), it's been written against 2.6.30-rc7:
>
> http://stuff.digriz.org.uk/ts78xx-fpga/fpga-device-work.diff
>
> and the my .config file is:
>
> http://stuff.digriz.org.uk/ts78xx-fpga/ts78xx.config
>
> One thing that might make people 'queasy' is that there is some wrapper
> code for platform drivers.  Although all the examples I have coded up
> use platform drivers and create platform devices, there are some drivers
> that are non-platform based in the works (GPIO, AVR, ISA bus, etc).  I
> felt the appropriate approach was (bearing in mind that different FPGA
> bitstreams implement possibly overlapping/partial duplicate
> functionality) to use a platform wrapper, the platform device being a
> child of my ts78xx-fgpa device.

... or you can make the ts78xx-fpga device a multi-function device
(drivers/mfd).

(In case the mfd-ers read this: recently I've been looking at using the mfd code
 for Amiga Zorro expansion boards. As most Zorro boards are made from discrete
 components, several of them are actually multi-function devices,
which prohibits
 me from just using zorro_driver).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
