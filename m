Return-Path: <linux-kernel-owner+w=401wt.eu-S969162AbXFHNVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969162AbXFHNVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 09:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938190AbXFHNVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 09:21:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:18177 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938173AbXFHNVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 09:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Em6I2zQIJbPtzo8Dtv1Sp/1tl6wSK3cMo0PbHSlPMlBx6eu2wjN3VyqXjt9/Seew/ytOzH10MIYQ729uGEvOB9qOhg584cimFTC3Nr+LVULnpUAW2+mAGWEHg3qO7A8cWXsgze59POH3KE57xxqVFEiqbVfjruaJU+Pa9lLmTM0=
Date: Fri, 8 Jun 2007 22:20:59 +0900
From: Tejun Heo <htejun@gmail.com>
To: Florin Iucha <florin@iucha.net>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@kernel.vger.org, jeff@garzik.org
Subject: [PATCH] libata: disable NCQ for HITACHI HTS541680J9SA00/SB21C7EP
Message-ID: <20070608132059.GG29122@htj.dyndns.org>
References: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no> <4666C477.1070603@shaw.ca> <20070607120430.GB30661@iucha.net> <466951DE.9070004@gmail.com> <20070608131157.GH30661@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608131157.GH30661@iucha.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HITACHI HTS541680J9SA00/SB21C7EP spuriously completes NCQ commands.
Blacklist it for NCQ.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/ata/libata-core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 636df4e..880cdd3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3787,6 +3787,8 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
+	/* Drives which do spurious command completion */
+	{ "HTS541680J9SA00",	"SB2IC7EP",	ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
 
