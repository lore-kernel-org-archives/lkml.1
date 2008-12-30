Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYL3Eot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYL3Eot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 23:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYL3Eoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 23:44:38 -0500
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:58801 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYL3Eoh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 23:44:37 -0500
X-Greylist: delayed 1434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 23:44:36 EST
From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
To: Julia Lawall <julia@diku.dk>, "Moore, Eric" <Eric.Moore@lsi.com>,
       "Support, Software" <support@lsi.com>,
       DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Tue, 30 Dec 2008 09:50:29 +0530
Subject: RE: [PATCH 3/7] drivers/message/fusion: Move a dereference below a
 NULL test
Thread-Topic: [PATCH 3/7] drivers/message/fusion: Move a dereference below a
 NULL test
Thread-Index: AclnK3vFF6Hl4blnRjeCotqhbWl9LADCl8jA
Message-ID: <B73941C4DE6A3D4EA1AE128E9565E2442392552FDF@inbmail01.lsi.com>
In-Reply-To: <Pine.LNX.4.64.0812260827250.25450@ask.diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK.

-----Original Message-----
From: Julia Lawall [mailto:julia@diku.dk]
Sent: Friday, December 26, 2008 12:58 PM
To: Moore, Eric; Support, Software; DL-MPT Fusion Linux; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
Subject: [PATCH 3/7] drivers/message/fusion: Move a dereference below a NULL test

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@disable is_null@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (E == NULL) S
  f(...,E->fld,...);
- if (E == NULL) S

@@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (!E) S
  f(...,E->fld,...);
- if (!E) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/fusion/mptctl.c     |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c index b89f476..c638171 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -308,10 +308,11 @@ static void mptctl_timeout_expired (MPT_IOCTL *ioctl)  {
        int rc = 1;

-       dctlprintk(ioctl->ioc, printk(MYIOC_s_DEBUG_FMT ": Timeout Expired! Host %d\n",
-                               ioctl->ioc->name, ioctl->ioc->id));
        if (ioctl == NULL)
                return;
+       dctlprintk(ioctl->ioc,
+                  printk(MYIOC_s_DEBUG_FMT ": Timeout Expired! Host %d\n",
+                  ioctl->ioc->name, ioctl->ioc->id));

        ioctl->wait_done = 0;
        if (ioctl->reset & MPTCTL_RESET_OK)
