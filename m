Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZEMD0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZEMD0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZEMD0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:26:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:43110 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZEMD0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:26:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AJ9J+EizcFzNgbPNebguUd1ACvw2vPldTER3L6uhsUq38VXLUOdm5k/3oI5qXpkaes
         6jtITHmCi0X4JfFzDRMIW9f/Q32+iYkcOQCL8+GHTE4irtavv9+vlwZpSOMfFSC/R6Io
         BOMPByv4Dadk/UJsM0EJsHYTMcIAqYtLnkZL4=
Date: Tue, 12 May 2009 20:20:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.29-rc4
Message-ID: <20090513032053.GA29919@dtor-d630.eng.vmware.com>
References: <20090511072135.GA4682@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090511072135.GA4682@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 11, 2009 at 08:21:35AM +0100, Sitsofe Wheeler wrote:
> Hi,
> 
> With the latest 2.6.29-rc4 I've been finding that my EeePC 900's
> trackpad is frequently not detected on boot:
> 
> USB Mass Storage support registered.
> eeepc kernel: [    4.343325] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> eeepc kernel: [    4.380623] serio: i8042 KBD port at 0x60,0x64 irq 1
> eeepc kernel: [    4.380790] serio: i8042 AUX port at 0x60,0x64 irq 12
> eeepc kernel: [    4.382951] mice: PS/2 mouse device common for all mice
> eeepc kernel: [    4.387850] rtc_cmos 00:03: RTC can wake from S4
> eeepc kernel: [    4.388828] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> eeepc kernel: [    4.388967] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
> eeepc kernel: [    4.389622] Linux video capture interface: v2.00
> eeepc kernel: [    4.390876] usbcore: registered new interface driver uvcvideo
> eeepc kernel: [    4.390966] USB Video Class driver (v0.1.0)
> eeepc kernel: [    4.394473] ACPI: Battery Slot [BAT0] (battery present)
> eeepc kernel: [    4.397288] cpuidle: using governor ladder
> eeepc kernel: [    4.401033] cpuidle: using governor menu
> eeepc kernel: [    4.401209] eeepc: Eee PC Hotkey Driver
> eeepc kernel: [    4.401951] eeepc: Hotkey init flags 0x41
> eeepc kernel: [    4.404559] eeepc: Get control methods supported: 0x101711
> eeepc kernel: [    4.405340] input: Asus EeePC extra buttons as /devices/virtual/input/input4
> eeepc kernel: [    4.419146] Advanced Linux Sound Architecture Driver Version 1.0.19.
> eeepc kernel: [    4.420902] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> eeepc kernel: [    4.421317] HDA Intel 0000:00:1b.0: setting latency timer to 64
> eeepc kernel: [    4.428154] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
> 
> The workaround has been to do the following as root:
> 
> echo i8042 > /sys/bus/platform/drivers/i8042/unbind ; echo i8042 > /sys/bus/platform/drivers/i8042/bind
> 
> Which results in:
> 
> eeepc kernel: [  100.138095] serio: i8042 KBD port at 0x60,0x64 irq 1
> eeepc kernel: [  100.138160] serio: i8042 AUX port at 0x60,0x64 irq 12
> eeepc kernel: [  100.173243] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio2/input/input6
> eeepc kernel: [  102.246050] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio3/input/input7
> 

Does it always discover it after rebind or you need to do that a few
times? Also, is the touchpad detected reliably if you boot an older
kernel?

> Having talked to Matthew a few months ago it sounds like the problem is
> that the something needs to be reset more aggressively at boot. This
> problem used to happen very rarely (maybe once every 50 or so boots)
> with older kernels but now seems to be happening every boot.
> 

Could you try booting with i8042.debug and send me dmesg of the case
when touchpad is not detected, please? BTW, why don't you have Elantech
support enabled?

-- 
Dmitry
