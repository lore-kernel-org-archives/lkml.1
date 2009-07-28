Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZG1XIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZG1XIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZG1XIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:08:50 -0400
Received: from kroah.org ([198.145.64.141]:42974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbZG1XD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:03:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:43 2009
Message-Id: <20090728225943.299958558@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 16/37] hwmon: (max6650) Fix lock imbalance
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-fix-lock-imbalance.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 025dc740d01f99ccba945df1f9ef9e06b1c15d96 upstream.

Add omitted update_lock to one switch/case in set_div.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/max6650.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -407,6 +407,7 @@ static ssize_t set_div(struct device *de
 		data->count = 3;
 		break;
 	default:
+		mutex_unlock(&data->update_lock);
 		dev_err(&client->dev,
 			"illegal value for fan divider (%d)\n", div);
 		return -EINVAL;


