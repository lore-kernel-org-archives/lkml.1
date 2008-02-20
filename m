Return-Path: <linux-kernel-owner+w=401wt.eu-S1763203AbYBTFBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763203AbYBTFBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbYBTFAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:00:50 -0500
Received: from smtp-out.google.com ([216.239.33.17]:14931 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYBTFAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:00:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=UeMujg30HLSA9Tdz+sBO7huXL39AuMt89CSpS1OQ01eoiYLC3MZBLKKKBAA86TqCz
	40B2has+OHXBAnO4IC+iA==
Message-Id: <20080220050032.219686000@menage.corp.google.com>
References: <20080220045408.289180000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Tue, 19 Feb 2008 20:54:09 -0800
From: Paul Menage <menage@google.com>
To: akpm@linux-foundation.org, pj@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Cpusets API: From: Paul Jackson <pj@sgi.com>
Content-Disposition: inline; filename=cgroup_write_uint_strstrip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Strip all trailing whitespace in cgroup_write_uint

This removes the need for people to remember to pass the -n flag to
echo when writing values to cgroup control files.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cgroup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: cpusets-2.6.25-rc2-mm1/kernel/cgroup.c
===================================================================
--- cpusets-2.6.25-rc2-mm1.orig/kernel/cgroup.c
+++ cpusets-2.6.25-rc2-mm1/kernel/cgroup.c
@@ -1321,10 +1321,7 @@ static ssize_t cgroup_write_uint(struct 
 		return -EFAULT;
 
 	buffer[nbytes] = 0;     /* nul-terminate */
-
-	/* strip newline if necessary */
-	if (nbytes && (buffer[nbytes-1] == '\n'))
-		buffer[nbytes-1] = 0;
+	strstrip(buffer);
 	val = simple_strtoull(buffer, &end, 0);
 	if (*end)
 		return -EINVAL;

--
