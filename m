Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbYKPIN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbYKPIN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYKPING
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:13:06 -0500
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:52448 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYKPINF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:13:05 -0500
Date: Sun, 16 Nov 2008 16:38:56 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after swap_cluster_max pages
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20081113171208.6985638e@bree.surriel.com>
References: <20081113171208.6985638e@bree.surriel.com>
Message-Id: <20081116163316.F205.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more point.

> Sometimes the VM spends the first few priority rounds rotating back
> referenced pages and submitting IO.  Once we get to a lower priority,
> sometimes the VM ends up freeing way too many pages.
> 
> The fix is relatively simple: in shrink_zone() we can check how many
> pages we have already freed and break out of the loop.
> 
> However, in order to do this we do need to know how many pages we already
> freed, so move nr_reclaimed into scan_control.

IIRC, Balbir-san explained the implemetation of the memcgroup 
force cache dropping feature need non bail out at the past reclaim 
throttring discussion.

I am not sure about this still right or not (iirc, memcgroup implemetation
was largely changed).

Balbir-san, Could you comment to this patch?



