Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbZAQAw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbZAQAw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 19:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZAQAwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 19:52:50 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:63720 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbZAQAwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 19:52:49 -0500
Message-ID: <49712BD8.6060603@lwfinger.net>
Date: Fri, 16 Jan 2009 18:52:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org
Subject: Re: [regression] hp-wmi: hangs system on boot
References: <200901170013.55786.elendil@planet.nl> <200901170131.22541.elendil@planet.nl>
In-Reply-To: <200901170131.22541.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Saturday 17 January 2009, Frans Pop wrote:
>> When I first booted .29-rc2 my HP 2510p notebook hung while loading
>> hp-wmi, which I have listed in /etc/modules. Hard poweroff was needed.
> 
> Reverting the following commit fixes the problems:
> 
> commit fe8e4e039dc3680681bf51af097af391f87038f8
> Author: Larry Finger <Larry.Finger@lwfinger.net>
> Date:   Fri Jan 9 16:40:54 2009 -0800
> 
>     hp-wmi: handle rfkill_register() failure

Ooops. There was a missing if statement. This one should fix it.


Index: linux-2.6/drivers/platform/x86/hp-wmi.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/hp-wmi.c
+++ linux-2.6/drivers/platform/x86/hp-wmi.c
@@ -441,6 +441,7 @@ static int __init hp_wmi_bios_setup(stru
 		bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
 		bluetooth_rfkill->user_claim_unsupported = 1;
 		err = rfkill_register(bluetooth_rfkill);
+		if (err)
 			goto register_bluetooth_error;
 	}


-------



