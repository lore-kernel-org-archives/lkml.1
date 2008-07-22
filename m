Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbYGVXgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbYGVXgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbYGVXat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:30:49 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:52336 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759422AbYGVXas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:30:48 -0400
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 19:30:48 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] kobject: Replace ALL occurrences of '/' with '!' instead of only the first one.
Date: Wed, 23 Jul 2008 01:25:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <20080722051805.GA17373@suse.de> <200807222012.39852.ioe-lkml@rameria.de> <20080722205015.GB3028@suse.de>
In-Reply-To: <20080722205015.GB3028@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200807230125.02532.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Oeser <ioe-lkml@rameria.de>

A recent patch from Kay Sievers <kay.sievers@vrfy.org>
replaced the first occurrence of '/' with '!' as needed for block devices.

Now do some cheap defensive coding and replace all of them to avoid future
issues in this area.

Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>
---

To answer your questions:
> Do you know of block devices with more than one?

No, just defensive coding :-)

> Nice, care to send a follow-on patch for this?

Linus just pulled, so I generated it against his latest tree.


 lib/kobject.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 7444015..ce2cf43 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -224,8 +224,7 @@ static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 		return -ENOMEM;
 
 	/* ewww... some of these buggers have '/' in the name ... */
-	s = strchr(kobj->name, '/');
-	if (s)
+	while (s = strchr(kobj->name, '/'))
 		s[0] = '!';
 
 	kfree(old_name);
-- 
1.5.4.3

