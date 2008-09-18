Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYIROHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYIROHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbYIROHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:07:05 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:36609 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbYIROHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:07:03 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 10:07:02 EDT
Message-ID: <48D25F4E.4050405@cateee.net>
Date: Thu, 18 Sep 2008 16:01:50 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
References: <s5hbpyny7bl.wl%tiwai@suse.de>
In-Reply-To: <s5hbpyny7bl.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Hi,
> 
> a topic that just came up in kernel summit is a script to remove
> unneeded kernel configs automatically to reduce the compile time.
> Incidentally, I already wrote such a script during the last SUSE hack
> week a couple of weeks ago, so I'd like to share here, hopefully to
> give an idea for further improvements.
> 
> The script checks the currently loaded modules and trims other
> CONFIG_XXX=m simply, and tries make oldconfig, and writes out the
> resultant .config in the current directory after some checks. 
> You can specify the config file via option,  as default, it reads from
> /proc/config.gz. 
> 
> The script is VERY hackish.  I should have begun with perl or whatever
> better script language, but I chose bash and co.  So, don't expect
> much code quality.  I'm no script guy after all :)

Check my AutoKernConf (http://cateee.net/autokernconf/), it has
huge (and automatically generated) database about drivers, modules,
and configuration, and it gives a minimal kernel configuration for the
most of the hardware hardware.

It needs a real maintainer and tools for non-hardware drivers
(fs, net, ...) and special hardware (CPU capabilities,
architecture specific drivers, etc).


> 
> 
> Takashi
> ---
> 
> #!/bin/sh
> 
> # this magic makes grep and co a lot faster
> export LANG=C
> 
> kroot=
> subarch=$(uname -i)

-i is wrong (gives "unkwnown" on Debian).
Check the main Makefile how to extract the architecture from uname.

> 	c)
> 	    oldconfig="$OPTARG"
> 	    if [ ! -f "$oldconfig" ]; then
> 		echo "Cannot find old config $oldconfig"
> 		exit 1
> 	    fi

Check also the config-* in /boot

> find_kconfig () {
>     module=$1
>     modregex=$(echo $1 | sed -e's/_/[_-]/g')
> 
>     grep -E '^[[:space:]]*obj-\$\([A-Za-z0-9_]*\)[[:space:]]*[+:]=.*[[:space:]]'"$modregex"'\.o' $tmpd/makefiles | \
> 	sed -e's/^.*://g' -e's/^[[:space:]]*obj-\$(\(.*\)).*$/\1/g'
> }

My python code works better (handle "alias", etc.).
Anyway I should send some cleanup patches to correct and
improve some ugly kernel Makefile.


ciao
	cate
