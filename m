Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbZKFWiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbZKFWiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760464AbZKFWiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:38:08 -0500
Received: from kroah.org ([198.145.64.141]:56823 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbZKFWWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:43 2009
Message-Id: <20091106221543.601055424@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [37/99] param: fix NULL comparison on oom
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=param-fix-null-comparison-on-oom.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rusty Russell <rusty@rustcorp.com.au>

commit d553ad864e3b3dde3f1038d491e207021b2d6293 upstream.

kp->arg is always true: it's the contents of that pointer we care about.

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/params.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -221,7 +221,7 @@ int param_set_charp(const char *val, str
 	 * don't need to; this mangled commandline is preserved. */
 	if (slab_is_available()) {
 		*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
-		if (!kp->arg)
+		if (!*(char **)kp->arg)
 			return -ENOMEM;
 	} else
 		*(const char **)kp->arg = val;


