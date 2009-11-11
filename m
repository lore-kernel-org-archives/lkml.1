Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZKKOEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZKKOEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZKKOEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:04:24 -0500
Received: from poutre.nerim.net ([62.4.16.124]:53561 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbZKKOEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:04:23 -0500
Date: Wed, 11 Nov 2009 15:04:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: resource_size doesn't change the resource
Message-ID: <20091111150424.37d56849@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resource_size function doesn't change the resource it operates on,
so the res parameter can be marked const. Same for the resource_type
function.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 include/linux/ioport.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.32-rc6.orig/include/linux/ioport.h	2009-09-28 10:29:17.000000000 +0200
+++ linux-2.6.32-rc6/include/linux/ioport.h	2009-11-11 13:22:27.000000000 +0100
@@ -126,11 +126,11 @@ extern int allocate_resource(struct reso
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
 resource_size_t resource_alignment(struct resource *res);
-static inline resource_size_t resource_size(struct resource *res)
+static inline resource_size_t resource_size(const struct resource *res)
 {
 	return res->end - res->start + 1;
 }
-static inline unsigned long resource_type(struct resource *res)
+static inline unsigned long resource_type(const struct resource *res)
 {
 	return res->flags & IORESOURCE_TYPE_BITS;
 }


-- 
Jean Delvare
