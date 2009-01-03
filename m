Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbZACWN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbZACWN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbZACWNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:13:20 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:54279 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZACWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:13:20 -0500
Date: Sat, 3 Jan 2009 23:14:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] Build failure in current mainline - firmware related
Message-ID: <20090103221455.GA8312@uranus.ravnborg.org>
References: <200901031247.14977.rjw@sisk.pl> <20090103204948.GA5388@uranus.ravnborg.org> <20090103205437.GA5499@uranus.ravnborg.org> <200901032243.28684.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901032243.28684.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Well, in the meantime I ran 'make modules_install V=1' and this is the
> last thing printed (the previous ones are not really interesting):
> 
> make -f /home/rafael/src/linux-2.6/scripts/Makefile.fwinst obj=firmware __fw_modinst
>   gcc -Wp,-MD,firmware/.ihex2fw.d -Ifirmware -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -o firmware/ihex2fw /home/rafael/src/linux-2.6/firmware/ihex2fw.c
> /home/rafael/src/linux-2.6/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system
> compilation terminated.
> make[3]: *** [firmware/ihex2fw] Error 1
> make[2]: *** [_modinst_post] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> It fails because of the attempt to compile ihex2fw .

I recall we had this bug in previous kernel too.
But it seems noone cared to fix it.

Looking at all this firmware stuff makes me sad.

We have a nice distributed way to keep all our
drivers and suddenly all the firmware are stored in
a central place.
So adding a driver requiores changes to a central file,
and moreso adding a file in a central place far far away from
the driver itself.

I recall a long long thread about this that I never even looked at.
[I commented on an early version of the implementation but never
looked at it seriously despite being copied on stuff].

What we should have done:
1) all firmware files should be stored with their drivers
so firmare are kept logically in the same place as the source.

2) we should add firmware information using config options
rather than a long list in a centeal file.

config MY_DRIVER_FIRMWARE
	string
	depends on MY_DRIVER
	default "drivers/my/driver.bin"
	
or something similar.

Then we could post process autoconf.h to have all relevant
information I think.

This is far away from solving this regression - just my
initial braindump seeing the implementation of
the firmware stuff.

	Sam
