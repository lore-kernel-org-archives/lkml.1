Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbYFFPht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbYFFPht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbYFFPhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:37:42 -0400
Received: from correo10.acens.net ([217.116.0.37]:36232 "EHLO
	correo10.acens.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776AbYFFPhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:37:41 -0400
Message-ID: <484959BD.6050407@eslack.org>
Date: Fri, 06 Jun 2008 17:37:33 +0200
From: Pau Oliva Fora <pau@eslack.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Eric Piel <eric.piel@tremplin-utc.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andrew Morton <akpm@osdl.org>,
       pavel@ucw.cz, Arjan van de Ven <arjan@infradead.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2.6.25.4]  hwmon: HP Mobile Data Protection System 3D
 ACPI driver -- please review!
References: <1212235533.3815.5.camel@localhost> <4846EBF5.2030406@tremplin-utc.net> <20080606102636.ZZRA012@mailhub.coreip.homeip.net> <484950D2.9070809@tremplin-utc.net>
In-Reply-To: <484950D2.9070809@tremplin-utc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Piel wrote:
>> I would recommend converting the input piece to input_polled_device
>> instead of managing the polling thread by yourselves.
> Yes, you are right, I had forgotten about this one! That said, for now 
> I'm working on removing the polling and relying only the interrupts. So 
> if it works that shouldn't be needed :-)
> 

I think going to interrupt-only approach will cause a problem in the HTC 
Shift:

In CTRL_REG2 (21h) if you set to 1 the Interrupt ENable (IEN) field the 
device shuts down.

I guess HTC took the "polling" approach in the windows driver, and they 
enable the interrupt when the sensor reports a "free fall" event, to 
have the disk parked and protect the hardware from being damaged.

Maybe you can keep the input_polled_device together with interrupts and 
select one or the other depending on DMI information (same as for 
swaping the axis, etc.)

Cheers,

	Pau Oliva
