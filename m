Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYCKNlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYCKNlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYCKNlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:41:39 -0400
Received: from 182-233-dsl.kielnet.net ([89.27.233.182]:57888 "EHLO
	einstein.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464AbYCKNli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:41:38 -0400
X-Greylist: delayed 1219 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 09:41:38 EDT
Message-ID: <47D6874C.8050404@aol.com>
Date: Tue, 11 Mar 2008 14:21:16 +0100
From: Oliver Schuster <olivers137@aol.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: win@iguana.be
Subject: Re: [WATCHDOG] v2.5.25-rc patches
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

WARNING

this patch can cause serious problems in the case, that someone use it with an it8712 rev. 8 and above.

You patch it8712f_wdt.c in function it8712f_wdt_update_margin(void):
...
+	if (revision >= 0x08)
+		superio_outw(units, WDT_TIMEOUT);
+	else
+		superio_outb(units, WDT_TIMEOUT);

but here you can't use superio_outw, because the bytes are swaped -- historical reason.
I suggest to substitute 
	superio_outw(units, WDT_TIMEOUT);
with
	superio_outb(units >> 8, WDT_TIMEOUT + 1);
	superio_outb(units, WDT_TIMEOUT);

or to change the patch with (only the referenced position above)

+	if (revision >= 0x08)
+		superio_outb(units >> 8, WDT_TIMEOUT + 1);
+
+	superio_outb(units, WDT_TIMEOUT);

Regards,
Oliver

