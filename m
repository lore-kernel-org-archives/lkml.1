Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0BIIQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 03:16:46 -0500
Received: from poutre.nerim.net ([62.4.16.124]:57145 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0BIIQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 03:16:44 -0500
Date: Tue, 9 Feb 2010 09:16:39 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: <linux-kernel@vger.kernel.org>, Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: [Q] i2c-taos-evm bus driver
Message-ID: <20100209091639.5b6e39a5@hyperion.delvare>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902152F0E@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190902152F0E@mi8nycmail19.Mi8.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/FtKSjvIasBp28EjCIH33Oxt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/FtKSjvIasBp28EjCIH33Oxt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Hartley,

Please send i2c-specific questions to the linux-i2c list, as specified
in MAINTAINERS.

On Mon, 8 Feb 2010 18:15:26 -0500, H Hartley Sweeten wrote:
> Is the i2c-taos-evm bus driver broken?

No, it works reasonably fine. I was using it myself no later than one
month ago. Out of curiosity, with which exact evaluation module do you
plan to use it?

> The Documentation says to use the following to tell the kernel that
> the device is on the first serial port:
> 
> # inputattach --taos-evm /dev/ttyS0
> 
> When I try that I get:
> 
> inputattach: invalid mode
> 
> I checked the source for inputattach on my system (Debian 5.0) and
> --taos-evm is missing.  And I have not been able to locate a newer
> version of the user-space utility.
> 
> Should this driver be marked broken?

No. What is broken is input-utils' upstream. I tried submitting patches
2.5 years ago:
  http://sourceforge.net/tracker/?group_id=3063&atid=303063

As you can see, nobody took care of them. Apparently I then did not
even bother sending the one adding support for the TAOS EVM.

The patch in question is still applied to the openSUSE version of the
input-utils package. If you have access to the openSUSE build system,
you can see it here:
  https://build.opensuse.org/package/view_file?file=input-utils-add-taos-evm-support.patch&package=input-utils&project=openSUSE%3A11.0

In case you don't, I'm attaching it too. I might add it to the patch
tracking system on sourceforge too. Not that I really expect upstream
to pick it in a timely manner, but at least other distributions would
see it and may decide to include it.

Hope that helps,
-- 
Jean Delvare

--MP_/FtKSjvIasBp28EjCIH33Oxt
Content-Type: text/x-patch; name=input-utils-add-taos-evm-support.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=input-utils-add-taos-evm-support.patch

---
 inputattach.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- utils.orig/inputattach.c	2007-06-22 10:25:32.000000000 +0200
+++ utils/inputattach.c	2008-05-11 15:41:57.000000000 +0200
@@ -376,6 +376,9 @@ struct input_types input_types[] = {
 { "--elo4002",		"-elo6b",	B9600, CS8 | CRTSCTS,		SERIO_ELO,	1,	0,	0,	NULL },
 { "--elo271-140",	"-elo4b",	B9600, CS8 | CRTSCTS,		SERIO_ELO,	2,	0,	0,	NULL },
 { "--elo261-280",	"-elo3b",	B9600, CS8 | CRTSCTS,		SERIO_ELO,	3,	0,	0,	NULL },
+#ifdef SERIO_TAOSEVM
+{ "--taos-evm",		"-taos",	B1200, CS8,			SERIO_TAOSEVM,	0,	0,	0,	NULL },
+#endif
 { "--dump",		"-dump",	B2400, CS8, 			0,		0,	0,	0,	dump_init },
 { "", "", 0, 0 }
 
@@ -421,6 +424,9 @@ int main(int argc, char **argv)
 		puts("  --elo4002       -elo6b    Elo touchscreen (legacy 6-byte protocol)");
 		puts("  --elo271-140    -elo4b    Elo touchscreen (legacy 4-byte protocol)");
 		puts("  --elo261-280    -elo3b    Elo touchscreen (legacy 3-byte protocol)");
+#ifdef SERIO_TAOSEVM
+		puts("  --taos-evm      -taos     TAOS evaluation module");
+#endif
 		puts("");
                 return 1;
         }

--MP_/FtKSjvIasBp28EjCIH33Oxt--
