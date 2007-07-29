Return-Path: <linux-kernel-owner+w=401wt.eu-S1763742AbXG2PN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763742AbXG2PN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764866AbXG2PBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:01:12 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47888 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763954AbXG2PBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:01:10 -0400
Date: Sun, 29 Jul 2007 17:00:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: acpi_battery_add(): use-after-free
Message-ID: <20070729150046.GM16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following use-after-free in 
acpi_battery_add():

<--  snip  -->

...
static int acpi_battery_add(struct acpi_device *device)
{
...
        if (result) {
                acpi_battery_remove_fs(device);
                kfree(battery);
        }

        mutex_unlock(&battery->mutex);
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

