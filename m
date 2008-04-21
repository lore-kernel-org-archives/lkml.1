Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYDUVMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYDUVMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYDUVMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:12:22 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:42094 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYDUVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:12:21 -0400
Message-ID: <480D032E.20204@freescale.com>
Date: Mon, 21 Apr 2008 16:12:14 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: Calling free_pages on part of the memory returned by get_free_pages?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to LDD3, if I call get_free_pages() to allocate X bytes, I have to
free all of those pages with free_pages().  The VM internals are a little bit
over my head, but I looked at the code and I didn't see why that is a requirement.

For example, let's say I want to allocated 6MB of physically-contiguous memory.
 If I call x = get_free_pages(11) to get 8MB.  What happens if I then do
"free_pages(x + 6 * 1024 * 1024, 9)"?

I remember doing this on the 2.4 kernel, and it never gave me any problems.

-- 
Timur Tabi
Linux kernel developer at Freescale
