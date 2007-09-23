Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbXIWNIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbXIWNIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 09:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbXIWNIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 09:08:13 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:15470 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbXIWNIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 09:08:12 -0400
From: Frans Pop <elendil@planet.nl>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.6.23-rc7] main.c: undefined reference to `acpi_sleep_prepare'
Date: Sun, 23 Sep 2007 15:08:06 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <200709230152.31120.elendil@planet.nl> <46F60AA2.1060500@gmail.com>
In-Reply-To: <46F60AA2.1060500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709231508.07674.elendil@planet.nl>
X-OriginalArrivalTime: 23 Sep 2007 13:08:09.0924 (UTC) FILETIME=[CA258040:01C7FDE2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 September 2007, Alexey Starikovskiy wrote:
> Frans Pop wrote:
> > drivers/built-in.o: In function `acpi_power_off_prepare':
> > main.c:(.text+0x32282): undefined reference to `acpi_sleep_prepare'
> > drivers/built-in.o: In function `acpi_hibernation_prepare':
> > main.c:(.text+0x3228c): undefined reference to `acpi_sleep_prepare'
>
> yep... acpi_sleep_prepare was put under CONFIG_SUSPEND spanning half of
> the file... this patch moves it out.

Compiles and works fine with that patch applied. Thanks.


One thing I noticed after booting with the kernel without CONFIG_SUSPEND.
/proc/acpi/sleep no longer lists S3 (as expected), but /proc/acpi/wakeup 
does still list the device status for S3, which seems somewhat 
inconsistent:

Device	S-state	  Status   Sysfs node
VIY0	  S3	 disabled  pci:0000:01:0b.0
USB1	  S3	 disabled  pci:0000:00:1d.0
USB2	  S3	 disabled  pci:0000:00:1d.1
USB4	  S3	 disabled  pci:0000:00:1d.7
AMDM	  S3	 disabled  pci:0000:00:1f.6
LID	  S4	*enabled   
PWRB	  S4	*enabled   

Not sure if it's worth fixing though.

Cheers,
FJP
