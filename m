Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZGMVYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZGMVYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZGMVYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:24:04 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:30137 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757179AbZGMVYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:24:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kyMvl1EBFUwn46g1YzJZk0jUlMXrcDnK7YgkggvOfosJyQCYm+8lbO4+fcjdg5GcIcCHZTiyDJ9F7STD7UaMFnNCsKAwY9UhG1wT9RQ4vbFS/wmz0U24JfuXAOAegPUL3QPHFodhxjNp4spigVWdWDeDuximUH8caUeNQhYnDVY=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: zmMOfK4VM1k7nqo63BTOdPyuOQ0eDJfE42txT8uMLp1D3gDyXIb1f2wk.jSV3G8i9a5_JAFAyytOy4cR_7DHo7meCYPJIhn.b4QsjMfrproJ5PDKVm_rGYUul3vmyk3bL5ikOTDWtny90oB4C_i7NpvDYciojaNT_Z9lN2Q1XjzZ9UHu0Io1OUCeTOH5a7bjubYBIPIhEXr3VDAGNUNIiju6QCl_.S9P3FChD.5a9W1x9LzSspdWMmd4My.NAgzFqW_56y_BMQCZgZybEFbHq.xn1dvrdSPPz0U4pkQSECAC3hSLUS52ZHCNkg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: linux-next: driver-core tree build warning
Date: Mon, 13 Jul 2009 14:23:59 -0700
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090713172646.55b9acee.sfr@canb.auug.org.au> <20090713175106.d2efbd60.sfr@canb.auug.org.au> <20090713171802.GB22728@kroah.com>
In-Reply-To: <20090713171802.GB22728@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907131423.59963.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 July 2009, Greg KH wrote:
> David, care to send patches fixing these warnings?

Here's a single patch:

=================== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

Some more attribute group pointers need to become const-friendly:

drivers/firewire/core-device.c:315: warning: assignment from incompatible pointer type
drivers/mtd/mtdcore.c:227: warning: initialization from incompatible pointer type
drivers/block/cciss.c:582: warning: initialization from incompatible pointer type

Two of these post-date the original constification patch; not sure
how I missed Firewire the first time.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/block/cciss.c          |    2 +-
 drivers/firewire/core-device.c |    2 +-
 drivers/mtd/mtdcore.c          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -572,7 +572,7 @@ static struct attribute_group cciss_dev_
 	.attrs = cciss_dev_attrs,
 };
 
-static struct attribute_group *cciss_dev_attr_groups[] = {
+static const struct attribute_group *cciss_dev_attr_groups[] = {
 	&cciss_dev_attr_group,
 	NULL
 };
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -312,7 +312,7 @@ static void init_fw_attribute_group(stru
 	group->groups[0] = &group->group;
 	group->groups[1] = NULL;
 	group->group.attrs = group->attrs;
-	dev->groups = group->groups;
+	dev->groups = (const struct attribute_group **) group->groups;
 }
 
 static ssize_t modalias_show(struct device *dev,
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -217,7 +217,7 @@ struct attribute_group mtd_group = {
 	.attrs		= mtd_attrs,
 };
 
-struct attribute_group *mtd_groups[] = {
+struct const attribute_group *mtd_groups[] = {
 	&mtd_group,
 	NULL,
 };

