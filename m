Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbXGKJGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbXGKJGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757161AbXGKJGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:06:47 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:29095 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757126AbXGKJGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:06:46 -0400
X-Greylist: delayed 2727 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 05:06:46 EDT
Message-ID: <469492F5.8070006@panasas.com>
Date: Wed, 11 Jul 2007 11:21:09 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: avoiding rejects
References: <20070710124422.a52b0458.akpm@linux-foundation.org>
In-Reply-To: <20070710124422.a52b0458.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2007 08:21:10.0508 (UTC) FILETIME=[7001A2C0:01C7C394]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> Most of these lists are unordered anyway, so inserting the new item at a
> randomly-chosen position is a better approach than just appending it.
> -
But you have lost the order you have just stated. 
"Order by time of addition" ascending ;)

Sometimes what I do is a diff with only post sync lines. 
With -p and the end of the list it mostly works.

consider this file
<list1>
BEGIN LIST
	I1
	I2
	I3
END LIST
..
...
</list1>

and consider this patch

<list2.patch>
--- list1	2007-07-11 10:33:26.000000000 +0300
+++ list2	2007-07-11 10:22:16.000000000 +0300
@@ -5,2 +5,3 @@ BEGIN LIST
+	add1
 END LIST
 ..
</list2.patch>

Now this will work. In fact you can apply this patch 
multiple times and it will keep adding Items. "patch"
will not warn about reverse patching, but ...
It will add Items from the top. Actually it will add
the Item at an absolute line in the file. At -# line 
stated at hunk header, like "-5" above.

Free Life
Boaz
