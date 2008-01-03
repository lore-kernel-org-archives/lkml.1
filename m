Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYACU4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYACU4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 15:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYACU4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 15:56:23 -0500
Received: from lap75545.ornl.gov ([160.91.210.54]:36474 "EHLO
	lap75545.ornl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYACU4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 15:56:23 -0500
Subject: Re: [ofa-general] Re: list corruption on ib_srp load in v2.6.24-rc5
From: David Dillow <dave@thedillows.org>
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, general@lists.openfabrics.org
In-Reply-To: <1199390957.7561.33.camel@lap75545.ornl.gov>
References: <20071223014407L.tomof@acm.org>
	 <1198689251.25003.2.camel@lap75545.ornl.gov> <adaprwkundh.fsf@cisco.com>
	 <20080103173330T.tomof@acm.org>
	 <1199390957.7561.33.camel@lap75545.ornl.gov>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jan 2008 15:51:25 -0500
Message-Id: <1199393485.7561.51.camel@lap75545.ornl.gov>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 15:09 -0500, David Dillow wrote:
> As for a better fix, I'm not sure.

Here's a better way than the strncmp. If this meets everyone's approval,
then I can roll up a proper commit.

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 44a340b..65c584d 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -265,7 +265,8 @@ EXPORT_SYMBOL_GPL(srp_rport_del);
 
 static int do_srp_rport_del(struct device *dev, void *data)
 {
-	srp_rport_del(dev_to_rport(dev));
+	if (scsi_is_srp_rport(dev))
+		srp_rport_del(dev_to_rport(dev));
 	return 0;
 }
 

