Return-Path: <linux-kernel-owner+w=401wt.eu-S1764141AbYHFJsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbYHFJsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYHFJsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:48:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:38945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYHFJsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:48:00 -0400
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
Date: Wed, 06 Aug 2008 15:16:23 +0530
Message-Id: <1218015983.3044.10.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, minor correction.

On Wed, 2008-08-06 at 15:05 +0530, Jaswinder Singh wrote:
> +
> +	mutex_lock(&fw_lock);
> +	tmp = kzalloc(sizeof(struct firmware_list), GFP_KERNEL);
> +	if (!tmp) {
>  		retval = -ENOMEM;
> -		goto out;
> +		goto error_kfree_fw;
> +	}
> +	tmp->name = kstrdup(name, GFP_KERNEL);
> +	if (!tmp->name) {
> +		retval = -ENOMEM;
> +		goto error_kfree_fw_list;
>  	}

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 0ba8857..c886113 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -428,12 +428,12 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	if (!firmware)
 		return -ENOMEM;
 
-	mutex_lock(&fw_lock);
 	tmp = kzalloc(sizeof(struct firmware_list), GFP_KERNEL);
 	if (!tmp) {
 		retval = -ENOMEM;
 		goto error_kfree_fw;
 	}
+	mutex_lock(&fw_lock);
 	tmp->name = kstrdup(name, GFP_KERNEL);
 	if (!tmp->name) {
 		retval = -ENOMEM;



