Return-Path: <linux-kernel-owner+w=401wt.eu-S935600AbXHHBHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935600AbXHHBHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 21:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXHHBHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 21:07:04 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:13988 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760109AbXHHBHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 21:07:03 -0400
Date: Tue, 7 Aug 2007 21:03:16 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Joerg Sommrey <jo@sommrey.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: bad temperature values from w83781d in 2.6.22
Message-ID: <20070808010316.GB3584@jupiter.solarsys.private>
References: <20070805183219.0d54802b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070805102604.GA9123@sommrey.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg:

(I tried to follow-up using the gmane.org mail/news gateway... didn't seem
to work.)

* Joerg Sommrey <jo@sommrey.de> [2007-08-05 12:26:04 +0200]:
> Hi,
> 
> after upgrading from 2.6.21 to 2.6.22 the CPU temperatures shown by
> w83781d look unreal.  They were in a range from 40°C when idle to
> 75°C under full load with 2.6.21.  The values shown now are in a very
> small range from 77°C to 82°C.  From the (low) noise of the fan I can
> tell that the temperature is <50°C.
> The third temperature shown is completely wrong.
> 
> I have a Tyan Tiger MPX board with a w83782d chip. Output from
> "sensors":
> 
> w83782d-i2c-0-2d
> Adapter: SMBus AMD768 adapter at 80e0
>  +5 V:     +4.81 V  (min =  +4.76 V, max =  +5.24 V)
> 3 VSB:     +3.30 V  (min =  +2.85 V, max =  +3.15 V)       ALARM
> chs3 Fan: 2122 RPM  (min = 2657 RPM, div = 4)              ALARM
> VRM2 Temp:  -208°C  (high =  -176°C, hyst =  -181°C)   sensor = transistor 
> CPU1 Temp: +78.5°C  (high =   +80°C, hyst =   +75°C)   sensor = transistor   ALARM
> CPU2 Temp: +77.5°C  (high =   +80°C, hyst =   +75°C)   sensor = transistor   ALARM
> alarms:
> beep_enable:
>           Sound alarm enabled
> 
> # cat /sys/bus/i2c/devices/0-002d/temp*_input
> -209000
> 77500
> 77500
> 
> Any ideas?

Please run the following commands as root (against both kernel versions) and
reply-to-all with the results:

	# modprobe i2c-dev
	# i2cdump -y 0 0x2d b 0 0x4e
	# i2cdump -y 0 0x48
	# i2cdump -y 0 0x49

Also, can you confirm that you're using the sensors.conf from here:
http://www.tyan.com/support_download_utility.aspx?model=s.s2466

Finally, can you confirm that "sensors -s" is running (without error) some
time during system startup, w/ both kernel versions?

Thanks & regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

