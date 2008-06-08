Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbYFHPoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbYFHPoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 11:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYFHPny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 11:43:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:49097 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYFHPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 11:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=f2RjdQd6mED54snbYx7wjq2cng0LhzJzFh711ieUnLTmk0QKb3JQY6WjzB2Ku1kbOM
         i4QOUO9ST0j1OqbCVc2WAcAEBlcIEyRk+CuFO0zwDZv8ZoeEHFYT3MeEiLtJckgtvUoJ
         loGHgz1I7KL5TErNejaLzyxUT9UdbZq8A94Eg=
Date: Sun, 8 Jun 2008 19:43:42 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, dwmw2@infradead.org
Subject: [PATCH] Fix race in power_supply_uevent.
Message-ID: <20080608154342.GA6935@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 54d29ad33e3483bcc7ca433a21cf294854e5154a introduced a race
in power_supply_uevent. Previously it checked that power_supply
is available by checking for dev->driver_data. But now dev->driver_data
is set before power_supply->dev is initialised.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/power/power_supply_sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index c444d6b..49215da 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -201,7 +201,7 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 	dev_dbg(dev, "uevent\n");
 
-	if (!psy) {
+	if (!psy || !psy->dev) {
 		dev_dbg(dev, "No power supply yet\n");
 		return ret;
 	}
-- 
1.5.5.1


-- 
With best wishes
Dmitry

