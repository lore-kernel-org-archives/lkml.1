Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851Ab0AUJYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0AUJYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670Ab0AUJYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:24:49 -0500
Received: from smtp.nokia.com ([192.100.105.134]:47918 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0AUJYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:24:47 -0500
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com, andi@firstfloor.org,
       david@fromorbit.com
In-Reply-To: <87fx609i29.fsf@gmail.com>
References: <87fx609i29.fsf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 11:22:55 +0200
Message-Id: <1264065775.3032.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Jan 2010 09:23:00.0637 (UTC) FILETIME=[538524D0:01CA9A7B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 20:51 -0800, Don Mullis wrote:
> The use of list_sort() by UBIFS looks like it could generate long
> lists; this alternative implementation scales better, reaching ~3x
> performance gain as list length approaches the L2 cache size.
> 
> Stand-alone program timings were run on a Core 2 duo L1=32KB L2=4MB,
> gcc-4.4, with flags extracted from an Ubuntu kernel build.  Object
> size is 552 bytes versus 405 for Mark J. Roberts' code.
> 
> Worst case for either implementation is a list length just over a POT,
> and to roughly the same degree, so here are results for a range of
> 2^N+1 lengths.  List elements were 16 bytes each including malloc
> overhead; random initial order.
> 

Could you please add a debugging function which would be compiled-out
normally, and which would check that on the output 'list_sort()' gives
really sorted list, and number of elements in the list stays the same.
You'd call this function before returning from list_sort(). Something
like:

#ifdef DEBUG_LIST_SORT
static int list_check(void *priv, struct list_head *head,
                      int (*cmp)(void *priv, struct list_head *a,
                                 struct list_head *b))
{
   /* Checking */
}
#else
#define list_check(priv, head, cmp) 0
#endif

This will provide more confidence in the algorithm correctness for
everyone who modifies 'list_sort()'.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

