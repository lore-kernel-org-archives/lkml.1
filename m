Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbYJ2VHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbYJ2VHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 17:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYJ2VG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 17:06:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:30376 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYJ2VGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 17:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ESpmOP432ItfoB1FRM1EE06lS4wAwipGh7inz9ovJxOQ6sldTlhvGwlPX56WrTjsXk
         XJUE0HvhUHP239ms3ih07NpsjM0vDLBdiqFYKbSRB0YkA+/02dRasTA0jCmO22rtIYMj
         mENODIriZQ+Jjc4aI31xhq8x2H9nR5jrjAYcE=
Message-ID: <4908D067.9080207@gmail.com>
Date: Wed, 29 Oct 2008 17:06:47 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: len.brown@intel.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] intel_menlo: max_state is unsigned, invalid test
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_state is unsigned, so the test is invalid.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I think max_state can only become -1, no? then probably a different
patch is required.
I may not be able to respond for a few weeks.

diff --git a/drivers/misc/intel_menlow.c b/drivers/misc/intel_menlow.c
index e00a275..980171d 100644
--- a/drivers/misc/intel_menlow.c
+++ b/drivers/misc/intel_menlow.c
@@ -121,7 +121,7 @@ static int memory_set_cur_bandwidth(struct thermal_cooling_device *cdev,
 	if (memory_get_int_max_bandwidth(cdev, &max_state))
 		return -EFAULT;
 
-	if (max_state < 0 || state > max_state)
+	if (max_state == -1 || state > max_state)
 		return -EINVAL;
 
 	arg_list.count = 1;

