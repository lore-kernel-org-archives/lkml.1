Return-Path: <linux-kernel-owner+w=401wt.eu-S2992435AbXCWPAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992435AbXCWPAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992426AbXCWPAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:00:33 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:36381 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992435AbXCWPAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:00:32 -0400
Message-ID: <4603EB81.4050308@lwfinger.net>
Date: Fri, 23 Mar 2007 10:00:17 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>	<1174433034.62033.16.camel@localhost>	<20070320223643.d8cbc3f6.akpm@linux-foundation.org>	<4601761F.4000302@lwfinger.net>	<20070321185900.GC3801@tuxdriver.com>	<20070321202225.GN10459@waste.org>	<20070321233917.0393dfd1.akpm@linux-foundation.org>	<20070322123508.3785fd30@gondolin.boeblingen.de.ibm.com>	<4602752A.5050109@lwfinger.net>	<20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>	<4602D137.4060402@lwfinger.net> <20070323111029.4089ccfb@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070323111029.4089ccfb@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Thu, 22 Mar 2007 13:55:51 -0500,
> Larry Finger <larry.finger@lwfinger.net> wrote:
>> I applied the debug patch, but I don't see any error codes being returned. This time I also got the
>> General Protection Faults. An excerpt of the log is attached.
> 
> Hm, I think I have an idea about what happened.
> 
> The firmware class tried to suppress the first KOBJ_ADD uevent by
> returning -ENODEV in firmware_uevent if FW_STATUS_READY was not set.
> This only worked as long as the return code of kobject_uevent was not
> checked in device_add. hack-to-make-wireless-work.patch made that first
> uevent return successfully, but this possible triggered some udev rule
> too early, leading to firmware load failures.
> 
> The following (completely untested) patch uses uevent_suppress to stop
> the uevent from being generated during device_add. Does this work for
> you?

Yes it does. Good job. On my first reboot with the new code, the startup of X hung with the black
screen and the big X cursor, but that seems to have been a single occurrence. With the patch, the
bcm43xx firmware is loaded and the device is working.

Thanks,

Larry
