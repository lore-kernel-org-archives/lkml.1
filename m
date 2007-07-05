Return-Path: <linux-kernel-owner+w=401wt.eu-S1762854AbXGEXJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762854AbXGEXJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762738AbXGEXJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:09:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:22688 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761237AbXGEXJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=UkvuLw3/+Zj3kB5GbEEBlbbo+hg+qJZR7CYdZsGKr0JrZcsHmwXRT/hPFhT7xN3ec29h7Y+lNKq/71vlB2pGVoWrHRepAvWYHJa7lmkTiOimTqqBV+DCEbg9Is/LAqUk3ZiVpMDxdDnF4k09a11Mh25kBVX9utq/TKnJ9aI2N3U=
Message-ID: <b8e9195f0707051609v36182409mc07f030cca790a7a@mail.gmail.com>
Date: Fri, 6 Jul 2007 01:09:34 +0200
From: "Guillaume LECERF" <glecerf@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Libertas: Fix regression in cmd.c introduced in commit 18c96c3497aa871608d57ca5e08de3558159a6c9
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 0aa41bf8b289cb22
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While reading the last libertas commits, I discovered that this commit
introduced a regression in the libertas wireless driver, inside cmd.c
:

commit 18c96c3497aa871608d57ca5e08de3558159a6c9
[PATCH] libertas: fix WPA associations by handling ENABLE_RSN correctly

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=18c96c3497aa871608d57ca5e08de3558159a6c9

The logic behind has been totally broken, and I think this patch is
worth reviewing.

Regards,

--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -241,7 +241,7 @@
                if (*enable)
                        penableRSN->enable = cpu_to_le16(cmd_enable_rsn);
                else
-                       penableRSN->enable = cpu_to_le16(cmd_enable_rsn);
+                       penableRSN->enable = cpu_to_le16(cmd_disable_rsn);
        }

        lbs_deb_leave(LBS_DEB_CMD);

-- 
Guillaume LECERF
GeeXboX developer
