Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZDGI2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZDGI2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZDGI2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:28:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:14928 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbZDGI2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=kjNkcrKXmICofHJJbRDexYMT7s7DQYQWdemYLgL4B0sfujfYaJt4pqJToKG626R+3D
         XOPntc2QJVqqZ6Urm+m3Wm24qL/2zd8WqqgRSMYzUMt26gsl21OyedTaLqiLuMfu1Gyh
         Cl4U2J0i3yB6I/Zkd6fTBVs0PJfTM5qWkT+Jk=
Date: Tue, 7 Apr 2009 10:28:11 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: 2.6.29, today's git changes, oops at boot, BUG: unable to
	handle kernel paging request at ffffffffa00f0016
Message-ID: <20090407082811.GA17700@damson.cased.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904070959.46784.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/7 Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>:
> On Tuesday 07 of April 2009, Vegard Nossum wrote:
>> 2009/4/6 Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>:
>> > Pulled Linus git few minutes ago and new oops at boot (happens on every
>> > boot). Yesterday git version was fine. Oopsed just while/after udev
>> > started.
>>
>> Hi, thanks for the report. Some musings below.

Can you try this patch?

The theory is that the init section of the module is unloaded before the
async function gets a chance to run.

Thanks,

Vegard


diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b0de631..3c7d894 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -903,7 +903,7 @@ static struct acpi_driver acpi_battery_driver = {
 		},
 };
 
-static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
+static void acpi_battery_init_async(void *unused, async_cookie_t cookie)
 {
 	if (acpi_disabled)
 		return;
