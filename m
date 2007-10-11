Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbXJKXDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbXJKXDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 19:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXJKXDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 19:03:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64794 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbXJKXDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 19:03:14 -0400
Date: Thu, 11 Oct 2007 16:02:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Cc: <Valdis.Kletnieks@vt.edu>, <linux-kernel@vger.kernel.org>
Subject: Re: TPM driver changes to support multiple locality
Message-Id: <20071011160221.87f77c61.randy.dunlap@oracle.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628CB9DD5@scsmsx412.amr.corp.intel.com>
References: <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com>
	<27383.1192045583@turing-police.cc.vt.edu>
	<A3258B497F1C1441AD36A2E8B45FD628CB9AEE@scsmsx412.amr.corp.intel.com>
	<20071011115429.92326cbd.randy.dunlap@oracle.com>
	<A3258B497F1C1441AD36A2E8B45FD628CB9CB2@scsmsx412.amr.corp.intel.com>
	<20071011143917.0eb75029.randy.dunlap@oracle.com>
	<A3258B497F1C1441AD36A2E8B45FD628CB9DD5@scsmsx412.amr.corp.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 15:46:03 -0700 Agarwal, Lomesh wrote:

> Attached is the patch which resolves all the comments.

Inline patches are preferred so that reviewers can comment on them
more easily.

What mail client are you using?

The patch has trailing CRs on each line ("DOS mode").

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Just verifying:  this TPM device has interrupts per locality?

+	/* check if interrupt is meant for this locality */
+	if (check_locality(chip, locality) < 0)
+		return IRQ_NONE;

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

init_tis() still seems to have some problems.

 static int __init init_tis(void)
 {
+#define DEVNAME_SIZE 10
+
 	int rc;
 
+	if ((locality < 0) || (locality > 4))
+		return PTR_ERR(pdev);

pdev hasn't been set (so it's NULL).

+		pdev = platform_device_register_simple(devname, -1, NULL, 0);
+		if (IS_ERR(pdev))
 			return PTR_ERR(pdev);

Error path above needs to call driver_unregister().


---
~Randy
