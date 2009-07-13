Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZGMDIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZGMDIX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbZGMDIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:08:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48250 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZGMDIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:08:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] switch free memory back to MIGRATE_MOVABLE
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20090713030444.GA2582@sli10-desk.sh.intel.com>
References: <20090713115803.b78a4f4f.kamezawa.hiroyu@jp.fujitsu.com> <20090713030444.GA2582@sli10-desk.sh.intel.com>
Message-Id: <20090713120549.6252.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 13 Jul 2009 12:08:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jul 13, 2009 at 10:58:03AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Mon, 13 Jul 2009 11:47:46 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > > When page is back to buddy and its order is bigger than pageblock_order, we can
> > > > switch its type to MIGRATE_MOVABLE. This can reduce fragmentation. The patch
> > > > has obvious effect when read a block device and then drop caches.
> > > > 
> > > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > 
> > > This patch change hot path, but there is no performance mesurement description.
> > > Also, I don't like modification buddy core for only drop caches.
> > > 
> > Li, does this patch imply fallback of migration type doesn't work well ?
> > What is the bad case ?
> The page is initialized as migrate_movable, and then switch to reclaimable or
> something else when fallback occurs, but its type remains even the page gets
> freed. When the page gets freed, its type actually can be switch back to movable,
> this is what the patch does.

This answer is not actual answer.
Why do you think __rmqueue_fallback() doesn't works well? Do you have
any test-case or found a bug by review?





