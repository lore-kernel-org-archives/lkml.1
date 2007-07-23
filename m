Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbXGWNSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbXGWNSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbXGWNSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:18:09 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57677 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbXGWNSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:18:06 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH 0/5] Dynamically allocated pageflags.
Date: Mon, 23 Jul 2007 23:05:12 +1000
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Message-Id: <200707232305.12364.nigel@nigel.suspend2.net>
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

As we all know, pageflags have been a scarce resource for a while now. These 
patches seek to help address that issue by adding support for a new type 
of 'dynamically allocated' pageflag.

The basic idea is that we use per node & zone bitmaps built out of order zero 
allocations, to replace bits in page->flags. Bitmaps can be sparse, being 
populated when a bit on the page is set, and returning zero for all bits in 
sparse pages. Untested hotplug support is included.

This method of storing the data does of course come with a performance hit. 
I've included some simple timing loops in #ifdef'd code that help quantify 
that.

Interestingly, the new implementation is actually quicker under some 
circumstances. In cases where the usage pattern involves operating on the 
flags for a number of pages in succession, the hit involved in getting the 
struct pages from main memory appears to be greater than that involved in 
calculating which unsigned long and bit to test.

Tested only on UP (x86_64) so far.

Regards,

Nigel
