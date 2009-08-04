Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbZHDThq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbZHDThq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZHDThq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:37:46 -0400
Received: from vena.lwn.net ([206.168.112.25]:49362 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZHDThp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:37:45 -0400
Date: Tue, 4 Aug 2009 13:35:17 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] flex_array: remove unneeded index calculation
Message-ID: <20090804133517.58429f31@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flex_array_get() calculates an index value, then drops it on the floor;
simply remove it.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/lib/flex_array.c b/lib/flex_array.c
index 0e7894c..08f1636 100644
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -254,7 +254,6 @@ void *flex_array_get(struct flex_array *fa, int element_nr)
 {
 	int part_nr = fa_element_to_part_nr(fa, element_nr);
 	struct flex_array_part *part;
-	int index;
 
 	if (element_nr >= fa->total_nr_elements)
 		return NULL;
@@ -264,6 +263,5 @@ void *flex_array_get(struct flex_array *fa, int element_nr)
 		part = (struct flex_array_part *)&fa->parts[0];
 	else
 		part = fa->parts[part_nr];
-	index = index_inside_part(fa, element_nr);
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
