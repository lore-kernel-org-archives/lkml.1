Return-Path: <linux-kernel-owner+w=401wt.eu-S1946323AbXBQAJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946323AbXBQAJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 19:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946334AbXBQAJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 19:09:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42194 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946323AbXBQAJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 19:09:35 -0500
Date: Fri, 16 Feb 2007 16:09:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [BUG?] register_blkdev: failed to get major for device mapper
Message-Id: <20070216160920.27c1167a.akpm@linux-foundation.org>
In-Reply-To: <200702161437.34063.eike-kernel@sf-tec.de>
References: <200702161437.34063.eike-kernel@sf-tec.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 14:37:28 +0100
Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> I can't bring up my machine with root LVM anymore using x86_64. The same 
> machine from same kernel tree boots fine as x86. The error message is quoted 
> in subject. The tree is at 86a71dbd3e81e8870d0f0e56b87875f57e58222b (for 
> those not using git: somewhere after 2.6.20).

Does this fix it?  I don't see why it would, but this was recently added.

--- a/block/genhd.c~a
+++ a/block/genhd.c
@@ -61,14 +61,6 @@ int register_blkdev(unsigned int major, 
 	/* temporary */
 	if (major == 0) {
 		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
-			/*
-			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
-			 * majors
-			 */
-			if ((60 <= index && index <= 63) ||
-					(120 <= index && index <= 127) ||
-					(240 <= index && index <= 254))
-				continue;
 			if (major_names[index] == NULL)
 				break;
 		}
_

