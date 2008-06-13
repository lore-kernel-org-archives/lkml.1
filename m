Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbYFMDKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbYFMDKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 23:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbYFMDKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 23:10:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57505 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbYFMDKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 23:10:44 -0400
Message-ID: <4851E4DC.6040603@cn.fujitsu.com>
Date: Fri, 13 Jun 2008 11:09:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kobject: should use kobject_put() in kset-example
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should call kobject_put() instead of kfree() if kobject_init_and_add()
returns an error, shouldn't we? Don't set up a bad example ;)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 samples/kobject/kset-example.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index b0a1b4f..7395c0b 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -211,7 +211,7 @@ static struct foo_obj *create_foo_obj(const char *name)
 	 */
 	retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s", name);
 	if (retval) {
-		kfree(foo);
+		kobject_put(&foo->kobj);
 		return NULL;
 	}
 
-- 
1.5.4.rc3
