Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZIXQsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZIXQsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZIXQs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:48:29 -0400
Received: from gw0.danplanet.com ([71.245.107.82]:43023 "EHLO
	mail.danplanet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752935AbZIXQs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:48:28 -0400
X-Greylist: delayed 1260 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 12:48:28 EDT
To: Rishikesh <risrajak@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@librato.com>, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
	<4ABB6EB6.2040204@linux.vnet.ibm.com>
From: Dan Smith <danms@us.ibm.com>
Date: Thu, 24 Sep 2009 09:27:30 -0700
Message-ID: <878wg41f65.fsf@caffeine.danplanet.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

R> I am getting following build error while compiling linux-cr kernel.

With CONFIG_CHECKPOINT=n, right?

R> 76569 net/unix/af_unix.c:528: error: ‘unix_collect’ undeclared here (not 
R> in a function)

Try the patch below.

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index e42a714..ee423d1 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -80,6 +80,7 @@ extern int unix_collect(struct ckpt_ctx *ctx, struct socket *sock);
 #else
 #define unix_checkpoint NULL
 #define unix_restore NULL
+#define unix_collect NULL
 #endif /* CONFIG_CHECKPOINT */
 
 #endif
