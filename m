Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYJ3DnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYJ3DnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 23:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYJ3Dm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 23:42:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:46166 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYJ3Dm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 23:42:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=m5pc3SQrT91PGCt/9Mi4RaWRvUTLNe3e2ttAjGrdwN/xhzBlsRcHT9qj3bAx9VTYIz
         U/qBzHyF5jaO2IhS0i/GJNgWPTu7F3PrQ+jscH9zbnqTQ8smx1s012x0b19nKvcgCRWB
         FkF9QgRyhvqNwSCTpN0JHbzcStaHRdHsfXRMc=
Message-ID: <b9df5fa10810292035p4c5a70eay44efae337a38d067@mail.gmail.com>
Date: Thu, 30 Oct 2008 09:35:24 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] resource.c: Fixing section mismatch warning .
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 LD      kernel/built-in.o
WARNING: kernel/built-in.o(.text+0xfcad): Section mismatch in
reference from the function reserve_region_with_split() to the
function .init.text:__reserve_region_with_split()
The function reserve_region_with_split() references
the function __init __reserve_region_with_split().
This is often because reserve_region_with_split lacks a __init
annotation or the annotation of __reserve_region_with_split is wrong.

This patch fixes the above warning.

Thanks.

Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/kernel/resource.c	2008-10-28 20:52:38.000000000 +0600
+++ linux-2.6/kernel/resource.c	2008-10-28 22:34:44.000000000 +0600
@@ -571,7 +571,7 @@ static void __init __reserve_region_with

 }

-void reserve_region_with_split(struct resource *root,
+void __init reserve_region_with_split(struct resource *root,
 		resource_size_t start, resource_size_t end,
 		const char *name)
 {
