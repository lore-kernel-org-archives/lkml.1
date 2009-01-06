Return-Path: <linux-kernel-owner+w=401wt.eu-S1753671AbZAFC3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbZAFC3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZAFC3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:29:23 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:1215 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZAFC3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:29:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=POUDQEu0t6IvqIkZ8DGpAXQsgnyMbhrj4gxOIVHRnSX/1HABE5+gvM3A08Px2Iy447
         7083VjKPfDd3tLmdrWvxZ6RjGCD46d6yVqMCd44OZxFfGxjoINljNJJVZ9bq6G8oPOGO
         wfSQ64y6ht9C+6qLNO8Dl8JnKTqnfkn/n6aSk=
Message-ID: <b9df5fa10901051829k31d61cafs1fa31178c371e0ce@mail.gmail.com>
Date: Tue, 6 Jan 2009 08:29:20 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] init: Fix section mismatch on do_mounts_md.c
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rakib Mullick <rakib.mullick@gmail.com>

This patch fixes the following warnings. autodetect_raid(void)
function lacks __init since
it refers to __initdata raid_autopart.	
	
  LD      init/mounts.o
WARNING: init/mounts.o(.text+0x20c): Section mismatch in reference
from the function autodetect_raid() to the variable
.init.data:raid_autopart
The function autodetect_raid() references
the variable __initdata raid_autopart.
This is often because autodetect_raid lacks a __initdata
annotation or the annotation of raid_autopart is wrong.

  LD      init/built-in.o
WARNING: init/built-in.o(.text+0x434): Section mismatch in reference
from the function autodetect_raid() to the variable
.init.data:raid_autopart
The function autodetect_raid() references
the variable __initdata raid_autopart.
This is often because autodetect_raid lacks a __initdata
annotation or the annotation of raid_autopart is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/init/do_mounts_md.c	2008-12-30 00:18:29.000000000 +0600
+++ linux-2.6/init/do_mounts_md.c	2009-01-05 20:09:32.000000000 +0600
@@ -271,7 +271,7 @@ static int __init raid_setup(char *str)
 __setup("raid=", raid_setup);
 __setup("md=", md_setup);

-static void autodetect_raid(void)
+static void __init autodetect_raid(void)
 {
 	int fd;
