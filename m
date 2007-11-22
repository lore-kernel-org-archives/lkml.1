Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbXKVAc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbXKVAc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 19:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbXKVAcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 19:32:48 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:59317 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbXKVAcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 19:32:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GefJm9lfEDhjUY97OR4i/hf9NZqk9Z+Bw+mpGRoG3D1+uS7ldhwTUW5wwKNsMYGeTM+NyNSQ49iqxmpZwf+xiiLN2PC6de7YQ++lq/OoMP0N1+AFoclpZFNyZmi+Y+xJinI7QCUaGUqn/0G/70B62vzlH+IJgsiwFpS+ytLFogo=
Message-ID: <4746469c0711211632y6137c772u392941398d1c24af@mail.gmail.com>
Date: Wed, 21 Nov 2007 16:32:38 -0800
From: "Mike Mohr" <akihana@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: tun device supplementary group ownership
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems to me that supplementary groups should be taken into account
when checking for permissions on a tun device.  Can someone comment on
my patch below; is it a reasonable approach?  If so, I'd like to
submit it for inclusion in the kernel under the GPL.

Please forward any responses to me directly in addition to the lkml.

Mike

--- tun.c       2007-11-16 10:14:27.000000000 -0800
+++ tun.c.new   2007-11-21 16:12:15.000000000 -0800
@@ -471,7 +471,8 @@
               if (((tun->owner != -1 &&
                     current->euid != tun->owner) ||
                    (tun->group != -1 &&
-                     current->egid != tun->group)) &&
+                     (current->egid != tun->group &&
+                      !groups_search(current->group_info, tun->group)))) &&
                    !capable(CAP_NET_ADMIN))
                       return -EPERM;
       }
