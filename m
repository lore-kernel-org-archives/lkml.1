Return-Path: <linux-kernel-owner+w=401wt.eu-S965000AbZLGW2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965000AbZLGW2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934639AbZLGW2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:28:01 -0500
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:59463 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934416AbZLGW2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:28:01 -0500
Message-ID: <4B1D8176.9040209@gmail.com>
Date: Mon, 07 Dec 2009 23:28:06 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091205 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, erbrochendes@gmx.de,
       divinespear@gmail.com, andjelo@gmx.net
Subject: Rt2x00 problem traced back to x86 ACPI/PCI/e820 handling.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Dec 2009 22:28:06.0864 (UTC) FILETIME=[8C6E3500:01CA778C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Yinghai,

For a while now we have seen reports of the rt2x00 driver not working correctly
where bogus information was read from the EEPROM. This resulted in a non-functional
driver.
It has been established that the problem has introduced itself sometimes in the 2.6.31
development cycle.

Lately the failures have been traced back to commit 5d423ccd7ba4285f1084e91b26805e1d0ae978ed
of a patch created by Yinghai and committed Ingo.

Reverting this patch seems to fix the problems with the rt2x00 driver.

Also, it has been established that another work-around is to supply the pci=use_crs boot parameter.

Do any of you have any idea as to what is going on here, and if this is something where the
rt2x00 driver is at fault, or where the x86 ACPI/PCI/e820 code is buggy?

So far I can establish that all the cases for which it is known what kind of HW it is that these
are all MSI laptops.

The related bug reports are:
	http://bugzilla.kernel.org/show_bug.cgi?id=14460
	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/404596

---
Gertjan.
