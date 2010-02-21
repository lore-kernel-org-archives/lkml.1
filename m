Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0BUW0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:26:45 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59936 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0BUW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:26:44 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B81B317.1050007@s5r6.in-berlin.de>
Date: Sun, 21 Feb 2010 23:26:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] firewire: ohci: add module parameter to activate
 quirk fixes
References: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de> <tkrat.cdeadccf2813dab1@s5r6.in-berlin.de>
In-Reply-To: <tkrat.cdeadccf2813dab1@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> This way, we can advise users of precompiled kernel packages to test
> existing quirk fixes on chips which have not been listed yet, without
> them having to build a kernel from source.

PS: Jay Fenlason posted a very similar patch already in November.  In
the meantime, the forceful disappearance of dual-buffer issues has made
such a facility less relevant, but the addition of the cycle timer quirk
fix made it a useful idea again.

> Note, to use this feature on a machine with more than one controller,
> steps like these are necessary:
> # lspci | grep 1394
> # ls /sys/bus/pci/drivers/firewire_ohci/
> # echo -n "0000:03:02.0" > /sys/bus/pci/drivers/firewire_ohci/unbind
> # echo 2 > /sys/module/firewire_ohci/parameters/quirks
> # echo -n "0000:03:02.0" > /sys/bus/pci/drivers/firewire_ohci/bind
> # echo 0 > /sys/module/firewire_ohci/parameters/quirks
[...]
>  
> +/* This overrides anything that was found in ohci_quirks[]. */
> +static int param_quirks;

PS2: The parameter can also be used to switch off quirk flags that were
hardwired into firewire-ohci's quirks table.  Simply specify a non-zero
quirks value but without any known flags; e.g. 0x100.
-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/
