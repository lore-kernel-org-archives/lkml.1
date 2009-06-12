Return-Path: <linux-kernel-owner+w=401wt.eu-S933535AbZFLJv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbZFLJv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933080AbZFLJvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:51:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58732 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbZFLJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:51:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Patrick Ringl <patrick.ringl@gmx.de>
Subject: Re: PATCH: README - Fix misleading pointer to the defconf directory
Date: Fri, 12 Jun 2009 11:50:39 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org,
       linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <4A321A3C.6030400@gmx.de>
In-Reply-To: <4A321A3C.6030400@gmx.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906121150.40332.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19efcY/G8riXCqDr8t8SiVH8ylun36+XdQWbCP
 GG1LlU1nJdjO1N7MzscNYi2R+KypBecEch9l8wLOuLNAJVkqES
 rLOEDueM+CoArPmwG91GQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009, Patrick Ringl wrote:
> the README simply points to a wrong/non-existent directory where the default
> configurations are not suited, hence the patch.

On six architectures, it's still the right directory, your patch breaks it.

> Signed-off-by: Patrick Ringl <patrick_@freenet.de>
>
> --- linux.orig/README   2009-06-10 05:05:27.000000000 +0200
> +++ linux/README        2009-06-12 10:46:15.000000000 +0200
> @@ -175,7 +175,7 @@
>                            Like above, but avoids cluttering the screen
>                            with questions already answered.
>         "make defconfig"   Create a ./.config file by using the default
> -                          symbol values from arch/$ARCH/defconfig.
> +                          symbol values from arch/$ARCH/configs/*_defconfig.
>         "make allyesconfig"
>                            Create a ./.config file by setting symbol
>                            values to 'y' as much as possible.

You could write e.g.

	default symbol values from one of arch/{$ARCH}/defconfig or
	arch/${ARCH}/configs/${PLATFORM}_defconfig, depending on
	the architecture.

It would also be consistent to list the specific defconfigs here, like

	"make ${PLATFORM}_defconfig"
			Create a ./.config file by using the default
			symbol values from
			arch/${ARCH}/configs/${PLATFORM}_defconfig.
			Use "make help" to see a list of the available
			platforms on your architecture.

Not also that your patch should be merged through a subsystem maintainer.
If you don't know who that is, use scripts/get_maintainer.pl.
For scripts/kconfig/* and README it suggests sending it to Sam, Roman and
linux-kbuild@vger.kernel.org, which sounds right.

	Arnd <><
