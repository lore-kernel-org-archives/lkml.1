Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbYGILyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbYGILyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbYGILyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:54:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:38546 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106AbYGILyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Cpm3oy+Az4VmnW6u7Z+mBBfFUP/23hbJChQRl6Er9nNDMT9P+4jlqQceQm1lwP5pe9
         6YR8hcZrkAISp75EYu3xfReN1/Ea2rdIE7mULXK7USE1u0qmGqJP47fyfYwpaKmuLPT9
         qg6hY1yxr3uecyYBCIPrQekyPRXbfVXLL+73I=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Wed, 09 Jul 2008 20:54:36 +0900
Message-Id: <20080709115436.14144.47963.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
References: <20080709115428.14144.7121.sendpatchset@rx1.opensource.se>
Subject: [PATCH 01/04] resource: add resource_size()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid one-off errors by introducing a resource_size() function.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/linux/ioport.h |    4 ++++
 kernel/resource.c      |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- 0001/include/linux/ioport.h
+++ work/include/linux/ioport.h	2008-07-09 12:59:04.000000000 +0900
@@ -113,6 +113,10 @@ extern int allocate_resource(struct reso
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
 resource_size_t resource_alignment(struct resource *res);
+static inline resource_size_t resource_size(struct resource *res)
+{
+	return res->end - res->start + 1;
+}
 
 /* Convenience shorthand with allocation */
 #define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
--- 0001/kernel/resource.c
+++ work/kernel/resource.c	2008-07-09 12:59:41.000000000 +0900
@@ -490,7 +490,7 @@ resource_size_t resource_alignment(struc
 {
 	switch (res->flags & (IORESOURCE_SIZEALIGN | IORESOURCE_STARTALIGN)) {
 	case IORESOURCE_SIZEALIGN:
-		return res->end - res->start + 1;
+		return resource_size(res);
 	case IORESOURCE_STARTALIGN:
 		return res->start;
 	default:
