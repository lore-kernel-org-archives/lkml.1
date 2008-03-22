Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYCVPK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYCVPK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 11:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYCVPKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 11:10:47 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:2547 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYCVPKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 11:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qLrwcmsbvboN6jBhjYJPRRoE8GKzVUY82u2KqMalkEIK5JrVrSPEyApq0Qvdbb2gmKAGKw7pLPGOBsYqdcSyNFQ54eZXrVZRLMM6cQEWhppobDrg85vwixXwMk45txT2qcLHNyG7+2BIuWS2JUdxjN7WGW32cvFqavCKHMNBEac=
Message-ID: <961aa3350803220810y25f13d1bk3769e738c9f80625@mail.gmail.com>
Date: Sun, 23 Mar 2008 00:10:45 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/5] cdrom: use list_head for cdrom_device_info list
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080322125535.GE15355@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080322030948.GA3665@APFDCB5C> <20080322031047.GB3665@APFDCB5C>
	 <20080322031204.GC3665@APFDCB5C> <20080322031248.GD3665@APFDCB5C>
	 <20080322125535.GE15355@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/3/22, Jens Axboe <jens.axboe@oracle.com>:
> On Sat, Mar 22 2008, Akinobu Mita wrote:
>  > Use list_head for cdrom_device_info list instead of opencoded
>  > singly list handling.
>
>
> Looks good, but you don't seem to be initializing ->list anywhere. Did
>  you test this?
>
>  I'd suggest just adding an INIT_LIST_HEAD() before the list_add() in
>  register_cdrom()

It seems that current list_add() implementation doesn't need
initalized new entry with/without CONFIG_DEBUG_LIST.
And the following change will show too many warnings with CONFIG_DEBUG_LIST.

Is it recommended to add an INIT_LIST_HEAD() before the list_add()?

Index: 2.6-git/lib/list_debug.c
===================================================================
--- 2.6-git.orig/lib/list_debug.c
+++ 2.6-git/lib/list_debug.c
@@ -8,6 +8,7 @@

 #include <linux/module.h>
 #include <linux/list.h>
+#include <linux/bug.h>

 /*
  * Insert a new entry between two known consecutive entries.
@@ -49,6 +50,7 @@ EXPORT_SYMBOL(__list_add);
  */
 void list_add(struct list_head *new, struct list_head *head)
 {
+	WARN_ON(!list_empty(new));
 	__list_add(new, head, head->next);
 }
 EXPORT_SYMBOL(list_add);
