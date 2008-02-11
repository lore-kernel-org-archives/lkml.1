Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYBKHaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYBKHaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 02:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYBKH34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 02:29:56 -0500
Received: from phunq.net ([64.81.85.152]:41192 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752498AbYBKH3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 02:29:55 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] vmsplice exploit fix (was: splice: fix user pointer access in get_iovec_page_array)
Date: Sun, 10 Feb 2008 23:29:50 -0800
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jens.axboe@oracle.com, akpm@linux-foundation.org,
       bastian@waldi.eu.org, ndenev@gmail.com, oliver.pntr@gmail.com
References: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ul/rHi8A5e3efRK"
Message-Id: <200802102329.50843.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ul/rHi8A5e3efRK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Kudos to all involved in the rapid response.  But.

Information on patching this vulnerability is not available front and 
center in many of the places you would expect: kernel.org front page, 
debian.org front page, covered on planet.debian.org but without a 
pointer to the patch, and so on.  So this post provides a subject line 
for Google to find, and for good measure mentions the word 
vulnerability.

Also,

   http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=464953

I think many users would first go to kernel.org on a day like today, as 
I did.  Nothing to see there.  We could do a way better job of getting 
the word out.

Patch attached as posted above by Pekka.  For the mortals among us:

   cd linux-2.6.recent && patch <fix.vmsplice.exploit.patch -p1

Regards,

Daniel

--Boundary-00=_ul/rHi8A5e3efRK
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix.vmsplice.exploit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix.vmsplice.exploit.patch"

Cc: <stable@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Bastian, can I have your Signed-off-by for this, please? Oliver, Niki, can 
you please confirm this closes the hole?

 fs/splice.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c
+++ linux-2.6/fs/splice.c
@@ -1237,6 +1237,9 @@ static int get_iovec_page_array(const st
 		if (unlikely(!base))
 			break;
 
+		if (unlikely(!access_ok(VERIFY_READ, base, len)))
+			break;
+
 		/*
 		 * Get this base offset and number of pages, then map
 		 * in the user pages.


--Boundary-00=_ul/rHi8A5e3efRK--
