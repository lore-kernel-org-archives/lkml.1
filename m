Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbXI3W5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbXI3W5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXI3W47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:56:59 -0400
Received: from rtr.ca ([76.10.145.34]:4214 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXI3W46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:56:58 -0400
Message-ID: <470029BA.3070106@rtr.ca>
Date: Sun, 30 Sep 2007 18:56:58 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 32-bit Athlon X2 won't poweroff 
References: <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl> <46FD05B8.2040302@rtr.ca> <46FD0724.5060009@rtr.ca> <1190991316.18681.38.camel@chaos> <46FD5BAF.8040304@rtr.ca> <20070930090032.GA2405@pul.manty.net> <46FFDB29.9040400@rtr.ca> <20070930175446.GA2472@pul.manty.net> <46FFEF41.8010104@rtr.ca> <20070930200336.GA2441@pul.manty.net> <470028C5.7020501@rtr.ca>
In-Reply-To: <470028C5.7020501@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>..
> So next is inside the kernel itself, at linux/kernel/sys.c :: sys_reboot(),
> where we see this code:
> 
>        /* Instead of trying to make the power_off code look like
>         * halt when pm_power_off is not set do it the easy way.
>         */
>        if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
>                cmd = LINUX_REBOOT_CMD_HALT;
> 
> This converts a "poweroff" into a "reboot" if no machine dependent
> power off function has been bound in (pm_power_off() is a function 
> pointer).

Duh.. fingers failed to follow brain:  that converts a "poweroff" into a "halt",
which is what you are seeing.  

> So for this to work, I believe that either ACPI or APM has to have been
> configured into the kernel (and the modules loaded).  Your kernel .config
> from earlier shows ACPI built-in to the kernel core, so it should be 
> present.
> 
> Unless you booted with noacpi or some such parameter..
> So let's have a look at the kernel boot logs,
> and you could also try CONGIG_ACPI_DEBUG=y
> 
> Bizarre (and nothing to do with my patch).
