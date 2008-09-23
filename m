Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbYIWVgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbYIWVgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYIWVge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:36:34 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:48534 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbYIWVge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:36:34 -0400
Message-ID: <48D960FE.7000409@euromail.se>
Date: Tue, 23 Sep 2008 23:34:54 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: nicolas@boichat.ch, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: applesmc: Add support for Macbook Pro 3
References: <48D927B3.5000207@euromail.se> <20080923133539.0146d940.akpm@linux-foundation.org>
In-Reply-To: <20080923133539.0146d940.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.35.94
X-Scan-Result: No virus found in message 1KiFY4-0000uV-6T.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KiFY4-0000uV-6T aa3562c22fb699475584bf1e06bb1c2c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 23 Sep 2008 19:30:27 +0200
> Henrik Rydberg <rydberg@euromail.se> wrote:
> 
>> This patch adds temperature sensor support for Macbook Pro 3.
> 
> For some reason I keep on having to fix rejects in
> applesmc_whitelist[].
> 

I have also experienced that problem. Odd. Please see my comment below.

Thanks,
Henrik

-----

> Here's what I now have:
> 
> /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
>  * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
> static __initdata struct dmi_system_id applesmc_whitelist[] = {
> 	{ applesmc_dmi_match, "Apple MacBook Air", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
> 		&applesmc_dmi_data[7]},
> 	{ applesmc_dmi_match, "Apple MacBook Pro 4", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4") },
> 		&applesmc_dmi_data[8]},
> 	{ applesmc_dmi_match, "Apple MacBook Pro 3", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3") },
> 		&applesmc_dmi_data[9]},

The two entries above are in reversed order in my tree, but
as you say, it does not matter.

> 	{ applesmc_dmi_match, "Apple MacBook Pro", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
> 		&applesmc_dmi_data[0]},
> 	{ applesmc_dmi_match, "Apple MacBook (v2)", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook2") },
> 		&applesmc_dmi_data[1]},
> 	{ applesmc_dmi_match, "Apple MacBook (v3)", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook3") },
> 		&applesmc_dmi_data[6]},
> 	{ applesmc_dmi_match, "Apple MacBook", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
> 		&applesmc_dmi_data[2]},
> 	{ applesmc_dmi_match, "Apple Macmini", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
> 		&applesmc_dmi_data[3]},
> 	{ applesmc_dmi_match, "Apple MacPro2", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
> 		&applesmc_dmi_data[4]},
> 	{ applesmc_dmi_match, "Apple iMac", {
> 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
> 	  DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
> 		&applesmc_dmi_data[5]},
> 	{ .ident = NULL }
> };
> 
> From my reading, we're still OK wrt the prefix-based string matching. 
> But please do double-chck this.
> 

