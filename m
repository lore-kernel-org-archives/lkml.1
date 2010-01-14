Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087Ab0ANKah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0ANKah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688Ab0ANKag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:30:36 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:32901 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab0ANKaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:30:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=W4XNQK0zGAzIDJN3axKdxuwO/Wzfl5a13Kz5AKrj/yJan5+M0/ZeAGPiff7OLabR2R
         1JqJI0HvSVH3dYJNbLetShhnuau1oiv1JuEXThGj3Rul2J8grNmsx8jBUWGMGA3gI/fB
         vN9HTv94X1KL8b4j4MYP+rOcQyi5Tm8b7yPHg=
Date: Thu, 14 Jan 2010 13:30:20 +0300
From: Dan Carpenter <error27@gmail.com>
To: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [patch] hwmon/amc6821: double unlock bug
Message-ID: <20100114103020.GA4939@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>,
	lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutex gets unlocked after we goto EXIT.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/hwmon/amc6821.c	2010-01-14 13:22:23.000000000 +0300
+++ devel/drivers/hwmon/amc6821.c	2010-01-14 13:22:30.000000000 +0300
@@ -686,7 +686,6 @@ static ssize_t set_fan1_div(
 		data->fan1_div = 4;
 		break;
 	default:
-		mutex_unlock(&data->update_lock);
 		count = -EINVAL;
 		goto EXIT;
 	}
