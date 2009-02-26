Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZBZM5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZBZM5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbZBZM5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:57:41 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50347 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZBZM5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:57:40 -0500
Message-ID: <49A691B8.4070906@linux.vnet.ibm.com>
Date: Thu, 26 Feb 2009 13:57:28 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Li Wei <W.Li@Sun.COM>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <49883CD7.2060602@linux.vnet.ibm.com> <1235616005.7351.8.camel@localhost> <49A66841.8020301@linux.vnet.ibm.com> <1235644389.13052.28.camel@localhost>
In-Reply-To: <1235644389.13052.28.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Wei wrote:
> On Thu, 2009-02-26 at 11:00 +0100, Peter Oberparleiter wrote:
>> Since a few RCs have been released since the last gcov-kernel patch 
>> post, I'll do a full re-post with a fix similar to the one you suggested 
>> included.
> 
> Thanks! It would be great if ".."s in object pathnames could also be
> supported in the forth coming re-post.

Sounds reasonable. I'll add a slightly modified patch:

---
 kernel/gcov/fs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.29-rc6/kernel/gcov/fs.c
===================================================================
--- linux-2.6.29-rc6.orig/kernel/gcov/fs.c
+++ linux-2.6.29-rc6/kernel/gcov/fs.c
@@ -502,6 +502,14 @@ static void add_node(struct gcov_info *i
 		if (curr == next)
 			continue;
 		*next = 0;
+		if (strcmp(curr, ".") == 0)
+			continue;
+		if (strcmp(curr, "..") == 0) {
+			parent = parent->parent;
+			if (!parent)
+				goto out_err;
+			continue;
+		}
 		node = get_child_by_name(parent, curr);
 		if (!node) {
 			node = new_node(parent, NULL, curr);

