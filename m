Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbZHFKog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbZHFKog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbZHFKof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:44:35 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:37219 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZHFKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=u3rPj7A1K4gZhv9ChoH8kGYsBgWOK4OAkSaQsVt9hcigg+8pfG6L7TcKUAClHrhV+f
         QHoWz9/JlgeJswowUBL4/vDHUPwyAp4ghLD2cPXu1OUhj+lian4MFjlnQP9NGmbUyiTo
         M6ftG6ML0/XH9M6wjOdR2bqWz46GDAksZtcoQ=
MIME-Version: 1.0
Date: Thu, 6 Aug 2009 18:44:34 +0800
Message-ID: <86bb1aef0908060344h37f304c1jf1138b4cb865cbe2@mail.gmail.com>
Subject: [PATCH] check-dbam1-if-there-is-only-one-DIMM-on-dbam0 in unganged 
	mode
From: wan wei <onewayforever@gmail.com>
To: borislav.petkov@amd.com, dougthompson@xmission.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    When I populated just one DIMM for each of the two channels  of
the cpu node in unganged mode,   there was only one channel found by
edac.
    In counting the channels, if there is only one DIMM found by
dbam0,  i think dbam1 should be checked for the other one  also.
    Below is the patch

Signed-off-by: Wan Wei<wanwei@dawning.com.cn>

---
 drivers/edac/amd64_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e2a10bc..afd210a 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1248,7 +1248,7 @@ static int f10_early_channel_count(struct amd64_pvt *pvt)
        /* If more than 2 DIMMs are present, then we have 2 channels */
        if (channels > 2)
                channels = 2;
-       else if (channels == 0) {
+       else if (channels <= 1) {
                /* No DIMMs on DCT0, so look at DCT1 */
                err = pci_read_config_dword(pvt->dram_f2_ctl, DBAM1, &dbam);
                if (err)
-- 
1.4.4.2
