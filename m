Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbYDQGtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbYDQGtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 02:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYDQGtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 02:49:10 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:56543 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYDQGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 02:49:09 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP S.A.L.
To: linux-kernel@vger.kernel.org
Subject: 2.6.25 released with bug, which leads to XFS crash?
Date: Thu, 17 Apr 2008 09:49:36 +0300
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804170949.36864.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again

I reported about http://bugzilla.kernel.org/show_bug.cgi?id=10421 , and it is triggerable on different loaded servers with XFS (squid with aufs), 
just it is happening even on heavy load after 1-2 days. IMHO such bugs is critical (same as getting kernel panic, and etc), 
cause they are unrecoverable, causing minor filesystem corruption, and only way to fix them - wakeup sysadmin. Worst thing, it is hapenning at night,
when i restart squid, and probably it is doing agressive unlinking stale cache entries. It doesn't do panic, or even oops, but filesystem will be disconnected, 
and squid will remain in loop trying to restart. Sure it is easy to restart it, but maybe it has to be OOPS? so at least i can do 
sysctl -w kernel.panic_on_oops = 1, and FS will be recovered on reboot.

Just want to warn people who is using XFS on loaded servers to keep attention while using 2.6.25, and if you face same bug, report to bugzilla.

-- 
------
Technical Manager
Virtual ISP S.A.L.
Lebanon
