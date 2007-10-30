Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXJ3VJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXJ3VJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbXJ3VJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:09:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:23097 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXJ3VJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=YHo/sOYQSQMSWYpIh4wDjUfrs9Urlh8otzSs0Dc4B0SYBvV8CNfqJo/rNDRqU+8XMisttd/bOTL7jhlnfHOC5JtRygZcOhUvRXXDISA1ToqgLhuX7/mqjZ0PYOLdrCy63H9Lp3tQl1I03Tn4gd+FrFOFmYl81lYZafi8YkMWFBA=
Message-ID: <47279D8C.5040708@gmail.com>
Date: Wed, 31 Oct 2007 00:09:32 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.24-rc1 regression] AC adapter state does not change after
 resume
References: <200710302324.52822.arvidjaar@mail.ru>
In-Reply-To: <200710302324.52822.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------070401020002090108000302"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070401020002090108000302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrey Borzenkov wrote:
> I suspect new ACPI AC adapter code but have to add some printk's to be sure.
> 
> To reproduce - plug in AC cord, suspend, unplug, resume - kpowersave and sysfs 
> still show AC adapter online. Or other way round.
> 
> -andrey
Please check if this patch helps.

Regards,
Alex.

--------------070401020002090108000302
Content-Type: text/x-diff;
 name="update_ac_state_on_sysfs_read.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="update_ac_state_on_sysfs_read.patch"

ACPI: AC: Update AC state on sysfs read

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/ac.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index e03de37..bb618c8 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -91,6 +91,9 @@ static int get_ac_property(struct power_supply *psy,
 			   union power_supply_propval *val)
 {
 	struct acpi_ac *ac = to_acpi_ac(psy);
+
+	if (acpi_ac_get_state(ac))
+		return 0;
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = ac->state;

--------------070401020002090108000302--
