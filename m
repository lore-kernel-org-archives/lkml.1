Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYBSAe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYBSAe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYBSAeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:34:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:57455 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYBSAeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:34:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=IGlfn+3kJRjZdWxVZ5hTTzmnj2oEt9iK7LwYXqNgkNn1in1GmrLbvgQdin2FFotgq
	WAhcUNrkL2sDlZJ6TRNAQ==
Date: Mon, 18 Feb 2008 16:32:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] documentation: fix firmware_sample_firmware_class to
 build
In-Reply-To: <20080218162216.ee1501fd.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.00.0802181629180.15109@chino.kir.corp.google.com>
References: <20080218162216.ee1501fd.randy.dunlap@oracle.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2008, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix firmware_sample_firmware_class module to build without error.
> sysfs.h already has the function prototypes and has them correctly.
> 
> Documentation/firmware_class/firmware_sample_firmware_class.c:37: error: conflicting types for 'sysfs_remove_bin_file'
> include/linux/sysfs.h:100: error: previous declaration of 'sysfs_remove_bin_file' was here
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  Documentation/firmware_class/firmware_sample_firmware_class.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> --- linux-2625-rc2-docsrc.orig/Documentation/firmware_class/firmware_sample_firmware_class.c
> +++ linux-2625-rc2-docsrc/Documentation/firmware_class/firmware_sample_firmware_class.c
> @@ -33,9 +33,6 @@ struct class_device_attribute *to_class_
>  	return container_of(_attr,struct class_device_attribute,attr);
>  }
>  
> -int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr);
> -int sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr);
> -
>  struct firmware_priv {
>  	char fw_id[FIRMWARE_NAME_MAX];
>  	s32 loading:2;

You'll need this as well, for the !CONFIG_SYSFS case.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/sysfs.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -169,8 +169,8 @@ static inline int sysfs_create_bin_file(struct kobject *kobj,
 	return 0;
 }
 
-static inline int sysfs_remove_bin_file(struct kobject *kobj,
-					struct bin_attribute *attr)
+static inline void sysfs_remove_bin_file(struct kobject *kobj,
+					 struct bin_attribute *attr)
 {
 	return 0;
 }
