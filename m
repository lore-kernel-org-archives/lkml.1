Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbXE1PQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbXE1PQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXE1PQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:16:39 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39278
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXE1PQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:16:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Mon, 28 May 2007 17:14:25 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705281216.51690.mb@bu3sch.de> <200705281609.49859.maxi@daemonizer.de>
In-Reply-To: <200705281609.49859.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281714.25841.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 16:09:46 Maximilian Engelhardt wrote:
> On Monday 28 May 2007, Michael Buesch wrote:
> > Can you give 2.6.16 a try? The diff is not that big and we might
> > be able to find out what broke if you find out 2.6.16 works.
> > You can also try later kernels like .17, .18, .19 to further
> > reduce the patch. (You could also git-bisect, if you have the time).
> >
> I did some testing and compiled some kernels and here are the results:
> 
> I was able to find out what causes the problems for me.  I did build two 
> 2.6.21.3 kernels, and one does work fine and the other doesn't.
> 
> This is a diff of the kernel configs I used:
> 
> --- /usr/src/linux-2.6.21.3-oldconfig1/.config  2007-05-28 13:41:15.000000000 
> +0200
> +++ /usr/src/linux-2.6.21.3/.config     2007-05-28 14:46:08.000000000 +0200
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
>  # Linux kernel version: 2.6.21.3
> -# Mon May 28 13:41:15 2007
> +# Mon May 28 14:46:09 2007
>  #
>  CONFIG_X86_32=y
>  CONFIG_GENERIC_TIME=y
> @@ -32,7 +32,7 @@
>  #
>  # General setup
>  #
> -CONFIG_LOCALVERSION="-oldconfig1"
> +CONFIG_LOCALVERSION=""
>  CONFIG_LOCALVERSION_AUTO=y
>  CONFIG_SWAP=y
>  CONFIG_SYSVIPC=y
> @@ -108,9 +108,9 @@
>  #
>  # Processor type and features
>  #
> -# CONFIG_TICK_ONESHOT is not set
> +CONFIG_TICK_ONESHOT=y
>  # CONFIG_NO_HZ is not set
> -# CONFIG_HIGH_RES_TIMERS is not set
> +CONFIG_HIGH_RES_TIMERS=y
>  # CONFIG_SMP is not set
>  CONFIG_X86_PC=y
>  # CONFIG_X86_ELAN is not set
> 
> The -oldconfig1 is the kernel that had no problems and the other shows the b44 
> problem. So if High Resolution Timer Support is disabled everything works 
> fine and if I enable it the problems do appear again.
> 
> I didn't test this on my 2.6.22-rc3 kernel yet, but I guess disabling High 
> Resolution Timer Support will also solve the problem there.
> 
> The older kernels I tried also work perfectly fine and they didn't have the 
> High Resolution Timer Support yet.

So, that's interesting, indeed.
Any idea what's going on, someone? Thomas?

-- 
Greetings Michael.
