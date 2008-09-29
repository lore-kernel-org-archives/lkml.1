Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYI2WS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYI2WS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYI2WQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:16:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:49565 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYI2WQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=NVmaNRGykSV/Kl751dCRnoTg81FGIpwpMP2tTlcNPDMJr4vTSDv8UGo8cBK5SEO/TN
         kVPzvcIhAw7biSAKpKHLpEwvu3+iXtfESWqNmSdZbjMv2hVqzN4tH0nV3qCU4dz+63+T
         CxiPl2/JBJsJ8R+AGeW+zpB3gRWXo4WjEqKy0=
Date: Tue, 30 Sep 2008 00:16:28 +0200
From: Karol Lewandowski <lmctlx@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: BUG: Commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a makes special keys on my T21 unusable after resume
Message-ID: <20080929221628.GA3082@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a causes my Thinkpad T21
to no longer generate any hotkey events (e.g. suspend fn-f4, switch-output
fn-f7, etc.) after resume.

It's regression from 2.6.25.  2.6.26 and 2.6.27-rc7 are broken,
reverting that commit on 2.6.27-rc7 makes keys work again.

Thanks.

[Rafael added for regression tracking ;]


commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Jun 6 11:49:33 2008 -0400

    ACPI: EC: Use msleep instead of udelay while waiting for event.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10724
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 0924992..5622aee 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -194,7 +194,7 @@ static int acpi_ec_wait(struct acpi_ec *ec, enum ec_event event, int force_poll)
 		while (time_before(jiffies, delay)) {
 			if (acpi_ec_check_status(ec, event))
 				return 0;
-			udelay(ACPI_EC_UDELAY);
+			msleep(1);
 		}
 	}
 	pr_err(PREFIX "acpi_ec_wait timeout, status = 0x%2.2x, event = %s\n",


