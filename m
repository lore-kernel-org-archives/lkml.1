Return-Path: <linux-kernel-owner+w=401wt.eu-S1760278AbZDSN3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760278AbZDSN3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbZDSN3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:29:32 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:55158 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZDSN3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KDh5igavvsaNP37FPv1Gdsbd3rVRYs7Z+Lsjn8JA6KkJ6Qxdd+nkHXPvEPeUKF0+hd
         kvz+hxiVoV/RaTUCreb9Yp42rWNGN8gWf3K8bzza+zbB2km2Fig4xbcfdYNHnhBOrYMc
         0qO9GUdu4Z5VL9Qcw4rOxfc6KSfKl15a7iI2A=
MIME-Version: 1.0
In-Reply-To: <200904161543.06238.oliver@neukum.org>
References: <4e5e476b0904091453m61ec4e81j7cfdef918bb3dfb3@mail.gmail.com>
	 <alpine.LRH.2.00.0904161210450.10907@twin.jikos.cz>
	 <4e5e476b0904160545h1f384dbdx4161a0a304ad4c80@mail.gmail.com>
	 <200904161543.06238.oliver@neukum.org>
Date: Sun, 19 Apr 2009 15:29:28 +0200
Message-ID: <4e5e476b0904190629s356a23bdw510f97510717d6b9@mail.gmail.com>
Subject: Re: linux-2.6.30rc1 mouse stuck with usb autosuspend enabled
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       oliver@neukum.name, Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 3:43 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Donnerstag 16 April 2009 14:45:12 schrieb Corrado Zoccolo:
> This is not the reliable way to check this. Please compile 2.6.29 with
> CONFIG_USB_DEBUG and post dmesg for a period of inactivity.

Oliver, you were right: 2.6.29 did not attempt at all to suspend the
mouse and its attached hum (2-x):
[   13.587023] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period
8, phase 4, 118 us
[   13.590044] uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period
8, phase 4, 118 us
[   13.647022] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period
8, phase 4, 118 us
[   23.350008] eth0: no IPv6 routers present
[   47.177896] usb usb1: usb resume
[   47.177903] ehci_hcd 0000:00:1d.7: resume root hub
[   47.219020] hub 1-0:1.0: hub_resume
[   47.219368] usb usb3: usb resume
[   47.219375] usb usb3: wakeup_rh
[   47.219390] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[   47.251011] hub 3-0:1.0: hub_resume
[   47.251162] usb usb4: usb resume
[   47.251165] usb usb4: wakeup_rh
[   47.251174] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   47.283014] hub 4-0:1.0: hub_resume
[   47.283155] usb usb5: usb resume
[   47.283159] usb usb5: wakeup_rh
[   47.283250] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   47.315013] hub 5-0:1.0: hub_resume
[   47.315273] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   48.454020] usb usb3: suspend_rh (auto-stop)
[   48.454039] usb usb4: suspend_rh (auto-stop)
[   48.454055] usb usb5: suspend_rh (auto-stop)
[   49.704028] hub 1-0:1.0: hub_suspend
[   49.704039] usb usb1: bus auto-suspend
[   49.704043] ehci_hcd 0000:00:1d.7: suspend root hub
[   49.704069] hub 3-0:1.0: hub_suspend
[   49.704073] usb usb3: bus auto-suspend
[   49.704076] usb usb3: suspend_rh
[   49.704090] hub 4-0:1.0: hub_suspend
[   49.704093] usb usb4: bus auto-suspend
[   49.704095] usb usb4: suspend_rh
[   49.704108] hub 5-0:1.0: hub_suspend
[   49.704111] usb usb5: bus auto-suspend
[   49.704114] usb usb5: suspend_rh

2.6.30-rc2, instead:
[  189.705618] uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period
8, phase 4, 118 us
[  189.708622] usb 2-1: usb auto-suspend
[  192.704031] hub 2-0:1.0: hub_suspend
[  192.704042] usb usb2: bus auto-suspend
[  192.704046] usb usb2: suspend_rh
* mouse click *
[  197.057083] usb usb2: usb resume
[  197.057088] usb usb2: wakeup_rh
[  197.089011] hub 2-0:1.0: hub_resume
[  197.089022] uhci_hcd 0000:00:1d.0: port 1 portsc 01a5,01
[  197.089028] hub 2-0:1.0: port 1: status 0303 change 0004
[  197.089043] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  197.089050] uhci_hcd 0000:00:1d.0: port 1 portsc 01a5,01
[  197.089056] usb 2-1: usb wakeup-resume
[  197.089063] usb 2-1: finish resume
[  197.096035] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period
8, phase 4, 118 us
[  197.096042] hub 2-0:1.0: resume on port 1, status 0
[  197.096046] hub 2-0:1.0: port 1, status 0303, change 0004, 1.5 Mb/s

Thanks,
Corrado

>
>        Regards
>                Oliver
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
