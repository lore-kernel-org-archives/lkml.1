Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbZAPHgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbZAPHgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZAPHgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:36:04 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:65088 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbZAPHgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=i4fvJjiqPi8OpFqggbIBzK72nnwPySFmK26C7NQ/WTjJrmtKjUH4rUaIIM5tZguZL7
         IL+PlQoAaGNOa15HYL7B3FHWw3qnhJI+OhdR3wv5aBhYA++UljrHcOeiwZrhP7TU9tae
         9qF+M1umN8KPVGh3RDkAvIsWxRtnscPup4rnk=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: david-b@pacbell.net, Magnus Damm <magnus.damm@gmail.com>,
       lethal@linux-sh.org, akpm@linux-foundation.org
Date: Fri, 16 Jan 2009 16:34:06 +0900
Message-Id: <20090116073406.11946.95332.sendpatchset@rx1.opensource.se>
Subject: [PATCH] gpiolib: request fix V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Fix request related issue in gpiolib:
 - fix request-already-requested handling in gpio_request()

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

  Changes since V1:
  - dropped the gpio_direction_input/output fixes

 drivers/gpio/gpiolib.c |    1 +
 1 file changed, 1 insertion(+)

--- 0001/drivers/gpio/gpiolib.c
+++ work/drivers/gpio/gpiolib.c	2008-12-26 13:09:50.000000000 +0900
@@ -789,6 +789,7 @@ int gpio_request(unsigned gpio, const ch
 	} else {
 		status = -EBUSY;
 		module_put(chip->owner);
+		goto done;
 	}
 
 	if (chip->request) {
