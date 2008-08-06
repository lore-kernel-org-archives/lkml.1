Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbYHFKSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbYHFKSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYHFKSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:18:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYHFKSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:18:01 -0400
Subject: Re: [PATCH] firmware: avoiding multiple replication for same
	firmware file
From: Jaswinder Singh <jaswinder@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
In-Reply-To: <1218015313.3044.6.camel@jaswinder.satnam>
References: <1217570459.2902.1.camel@jaswinder.satnam>
	 <20080805140327.16494fb0.akpm@linux-foundation.org>
	 <1218015313.3044.6.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 15:46:24 +0530
Message-Id: <1218017784.3044.14.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 15:05 +0530, Jaswinder Singh wrote:
> @@ -445,12 +484,22 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
>  		retval = -ENOENT;
>  		release_firmware(fw_priv->fw);
>  		*firmware_p = NULL;
> +		list_del(&tmp->list);
> +		kfree(tmp->name);
> +		kfree(tmp);
>  	}
>  	fw_priv->fw = NULL;
>  	mutex_unlock(&fw_lock);

This is also not required as we are doing this in release_firmware().
So :

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c886113..7b268d1 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -484,9 +484,6 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		retval = -ENOENT;
 		release_firmware(fw_priv->fw);
 		*firmware_p = NULL;
-		list_del(&tmp->list);
-		kfree(tmp->name);
-		kfree(tmp);
 	}
 	fw_priv->fw = NULL;
 	mutex_unlock(&fw_lock);


