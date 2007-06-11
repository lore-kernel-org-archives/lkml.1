Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbXFKLB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbXFKLB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXFKLBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:01:15 -0400
Received: from ns3.ipt.fr ([84.246.228.162]:38145 "EHLO ns3.octant-fr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbXFKLBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:01:14 -0400
X-Greylist: delayed 1938 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 07:01:14 EDT
Message-ID: <466D2419.7040106@octant-fr.com>
Date: Mon, 11 Jun 2007 12:29:45 +0200
From: Tobias Oed <tobias.oed@octant-fr.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: jmorris@namei.org
CC: tobias.oed@octant-fr.com, sds@tycho.nsa.gov, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [RESENT][TRIVIAL][PATCH] SELinux: Use %lu for inode->i_no when printing
 avcs
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resending this to a wider audience since the first attempt was mangled
and I haven't heard anything in a week.

Inode numbers are unsigned long and so need to %lu as format string of
printf. I have no idea why the __attribute__((format,..)) of 
audit_log_format
doesn't give us a warning.
Compile tested only.

Signed-off-by: Tobias Oed <tobias.oed@octant-fr.com>

--- linux-2.6.21.3/security/selinux/avc.c.orig  2007-06-11
12:19:28.000000000 +0200
+++ linux-2.6.21.3/security/selinux/avc.c       2007-06-04
21:19:22.000000000 +0200
@@ -584,7 +584,7 @@ void avc_audit(u32 ssid, u32 tsid,
                                }
                        }
                        if (inode)
-                               audit_log_format(ab, " dev=%s ino=%ld",
+                               audit_log_format(ab, " dev=%s ino=%lu",
                                                 inode->i_sb->s_id,
                                                 inode->i_ino);
                        break;

