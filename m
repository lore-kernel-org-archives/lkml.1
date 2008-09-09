Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYIIRf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYIIRf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYIIRfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:35:51 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:51251 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753778AbYIIRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:35:51 -0400
Message-ID: <48C6B3F4.5050406@suse.de>
Date: Tue, 09 Sep 2008 21:35:48 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5 acpi: EC Storm error message on bootup
References: <1254.69.2.248.210.1220390835.squirrel@webmail.wolfmountaingroup.com>       <48C60685.60303@suse.de>    <1044.69.2.248.210.1220971907.squirrel@webmail.wolfmountaingroup.com> <1702.69.2.248.210.1220972366.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1702.69.2.248.210.1220972366.squirrel@webmail.wolfmountaingroup.com>
Content-Type: multipart/mixed;
 boundary="------------090108090102090107000208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090108090102090107000208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


jmerkey@wolfmountaingroup.com wrote:
> Oh shit, my mistake.  I applied it to a 2.2.26.4 tree.  please disregard. 
> I will test it shortly.
Thanks!
I've found more slippery place, could you please add attached patch if the first one doesn't work?

Regards,
Alex.

--------------090108090102090107000208
Content-Type: text/x-diff;
 name="1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="1.diff"

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 97168d4..961b327 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -538,7 +538,7 @@ static u32 acpi_ec_gpe_handler(void *data)
 	state = acpi_ec_read_status(ec);
 
 	gpe_transaction(ec, state);
-	if ((status & ACPI_EC_FLAG_IBF) == 0)
+	if (ec_transaction_done(ec) && (status & ACPI_EC_FLAG_IBF) == 0)
 		wake_up(&ec->wait);
 
 	status = ec_check_sci(ec, state);

--------------090108090102090107000208--
