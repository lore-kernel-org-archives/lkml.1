Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbZEKH3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbZEKH3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZEKH3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:29:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:7079 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZEKH3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=BNcvuwED/zI3sKydhFAtrzBY4iDChF5jAs+EsE5TPS4pBxdEjXeve+vC/vyY/l3pKR
         OuP6pZ1ywKvn02HkbMQz+QhpdNT64fPIAG70rIlhF6hmrpJnb+MIpQgjQo+u5QyXM5Ew
         Emu5Tke7yEQRdkhHqViSb9MJ9dXjIIbHfTV+I=
Date: Mon, 11 May 2009 16:29:00 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
Message-Id: <20090511162900.f372edd1.minchan.kim@barrios-desktop>
In-Reply-To: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, David. 

On Sat, 9 May 2009 15:46:39 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> The oom killer must be invoked regardless of the order if the allocation
> is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> free some memory.
>

Hmm.. if __alloc_pages_may_oom fail to allocate free page due to order > PAGE_ALLOC_COSTRY_ORDER,

It will go to nopage label in __alloc_pages_slowpath.
Then it will show the page allocation failure warning and will return. 
Retrying depends on caller. 

So, I think it won't loop forever. 
Do I miss something ?

In addition, the OOM killer can help for getting the high order pages ?
 
-- 
Kinds Regards
Minchan Kim
