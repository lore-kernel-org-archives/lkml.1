Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab0BDDFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:05:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:46793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab0BDDFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:05:12 -0500
Message-ID: <4B6A3AED.1000102@kernel.org>
Date: Thu, 04 Feb 2010 12:11:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [2.6.33-rc6-git regression] idr fix breaks Xorg
References: <20100204012837.GC538@hexapodia.org>
In-Reply-To: <20100204012837.GC538@hexapodia.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 03:05:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2010 10:28 AM, Andy Isaacson wrote:
> On my Dell Latitude e4300 commit 859ddf0974 ("idr: fix a critical
> misallocation bug") causes Xorg to segfault with the following
> backtrace:

Does the following patch make any difference?

diff --git a/lib/idr.c b/lib/idr.c
index ba7d37c..a96c604 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -140,7 +140,8 @@ static int sub_alloc(struct idr *idp, int *starting_id, struct idr_layer **pa)
 	id = *starting_id;
  restart:
 	p = idp->top;
-	l = p->layer;
+	l = idp->layers;
+	pa[l--] = NULL;
 	while (1) {
 		/*
 		 * We run around this while until we reach the leaf node...


-- 
tejun
