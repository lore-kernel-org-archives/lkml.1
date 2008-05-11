Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYEKT6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYEKT6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbYEKT6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:58:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:39032 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbYEKT6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fsXR5pycEf7Fe5aD9GbHvyDXqdYaHR98t16YGmJPgvDWOpmObQ2lqQUYI1ohL+OEM5ZBW5RjGRTV0xTtk1yzrT4gDLCQCXNukw3S5+73TpIdF9C6rcExg3Sc9ucxyDWxfAIx0hfuVC9jn+lfKa1sTwnfNr2qwdZlXC/zhLrQ1zc=
Date: Sun, 11 May 2008 21:57:40 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC] [PATCH] s390/net/claw: don't ignore return value of find_link
Message-ID: <20080511195736.GF19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_link checked some conditions but then ignored it - fix it.
return negative error for consistency with the rest of kernel

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
please check if it's correct patch
---
 drivers/s390/net/claw.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -1722,18 +1722,18 @@ find_link(struct net_device *dev, char *host_name, char *ws_name )
 		case  PACKING_ASK:
 			if ((memcmp(WS_APPL_NAME_PACKED, host_name, 8)!=0) ||
 			    (memcmp(WS_APPL_NAME_PACKED, ws_name, 8)!=0 ))
-        	             rc = EINVAL;
+				rc = -EINVAL;
 			break;
 		case  DO_PACKED:
 		case  PACK_SEND:
 			if ((memcmp(WS_APPL_NAME_IP_NAME, host_name, 8)!=0) ||
 			    (memcmp(WS_APPL_NAME_IP_NAME, ws_name, 8)!=0 ))
-        	        	rc = EINVAL;
+				rc = -EINVAL;
 			break;
 		default:
 	       		if ((memcmp(HOST_APPL_NAME, host_name, 8)!=0) ||
 		    	    (memcmp(p_env->api_type , ws_name, 8)!=0))
-        	        	rc = EINVAL;
+				rc = -EINVAL;
 			break;
 	}
 
@@ -1741,7 +1741,7 @@ find_link(struct net_device *dev, char *host_name, char *ws_name )
         printk(KERN_INFO "%s:%s Exit on line %d\n",
 		dev->name,__func__,__LINE__);
 #endif
-        return 0;
+	return rc;
 }    /*    end of find_link    */
 
 /*-------------------------------------------------------------------*
-- 
