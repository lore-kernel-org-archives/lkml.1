Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbXC2Ohf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbXC2Ohf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 10:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbXC2Ohf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 10:37:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38362 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbXC2OhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 10:37:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Date: Thu, 29 Mar 2007 16:39:40 +0200
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
References: <460B6E4B.3060004@gmail.com>
In-Reply-To: <460B6E4B.3060004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291639.41515.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 29 March 2007 09:44, Jiri Slaby wrote:
> Hi,
> 
> I'm getting this while trying to swsups the machine in -rc5, -rc4 is fine:
> 
> Disabling non-boot CPUs
> CPU 1 is now offline
> SMP alternatives: switching to UP code
> CPU1 is down
> swsusp: critical section:
> swsusp: Need to copy 131380 pages
> swsusp: Not enough free memory
> Error -12 suspending
> Enabling non-boot CPUs ...
> 
> # cat /sys/power/resume
> 8:6
> # cat /proc/swaps
> Filename                                Type            Size    Used    Priority
> /dev/sda6                               partition       1004020 0       -1
> 
> Any other info needed?

Beats me.  There were no changes that could result in such a thing between
-rc4 and -rc5, at least not in the swsusp department.

Could you please try to bisect?

> BTW. is this OK on resume?
> PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100006, w
> iting 100002)
> pnp: Failed to activate device 00:04.
> pnp: Failed to activate device 00:05.
>  usbdev5.3_ep00: PM: resume from 0, parent 5-4 still 2
> 
> # ll /sys/bus/pnp/devices/00\:0{4,5}/driver
> lrwxrwxrwx 1 root root 0 2007-03-29 09:16 /sys/bus/pnp/devices/00:04/driver
> -> ../../../bus/pnp/drivers/i8042 kbd
> lrwxrwxrwx 1 root root 0 2007-03-29 09:16 /sys/bus/pnp/devices/00:05/driver
> -> ../../../bus/pnp/drivers/i8042 aux

Well, I don't think so.

Greetings,
Rafael
