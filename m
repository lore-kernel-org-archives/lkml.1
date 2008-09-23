Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbYIWUgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbYIWUgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYIWUgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:36:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbYIWUgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:36:42 -0400
Date: Tue, 23 Sep 2008 13:35:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: nicolas@boichat.ch, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: applesmc: Add support for Macbook Pro 3
Message-Id: <20080923133539.0146d940.akpm@linux-foundation.org>
In-Reply-To: <48D927B3.5000207@euromail.se>
References: <48D927B3.5000207@euromail.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 19:30:27 +0200
Henrik Rydberg <rydberg@euromail.se> wrote:

> This patch adds temperature sensor support for Macbook Pro 3.

For some reason I keep on having to fix rejects in
applesmc_whitelist[].

Here's what I now have:

/* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
 * So we need to put "Apple MacBook Pro" before "Apple MacBook". */
static __initdata struct dmi_system_id applesmc_whitelist[] = {
	{ applesmc_dmi_match, "Apple MacBook Air", {
	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir") },
		&applesmc_dmi_data[7]},
	{ applesmc_dmi_match, "Apple MacBook Pro 4", {
	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4") },
		&applesmc_dmi_data[8]},
	{ applesmc_dmi_match, "Apple MacBook Pro 3", {
	  DMI_MATCH(DMI_BOARD_VENDOR, "Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3") },
		&applesmc_dmi_data[9]},
	{ applesmc_dmi_match, "Apple MacBook Pro", {
	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBookPro") },
		&applesmc_dmi_data[0]},
	{ applesmc_dmi_match, "Apple MacBook (v2)", {
	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook2") },
		&applesmc_dmi_data[1]},
	{ applesmc_dmi_match, "Apple MacBook (v3)", {
	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook3") },
		&applesmc_dmi_data[6]},
	{ applesmc_dmi_match, "Apple MacBook", {
	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME,"MacBook") },
		&applesmc_dmi_data[2]},
	{ applesmc_dmi_match, "Apple Macmini", {
	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
		&applesmc_dmi_data[3]},
	{ applesmc_dmi_match, "Apple MacPro2", {
	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
		&applesmc_dmi_data[4]},
	{ applesmc_dmi_match, "Apple iMac", {
	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
	  DMI_MATCH(DMI_PRODUCT_NAME,"iMac") },
		&applesmc_dmi_data[5]},
	{ .ident = NULL }
};

>From my reading, we're still OK wrt the prefix-based string matching. 
But please do double-chck this.

