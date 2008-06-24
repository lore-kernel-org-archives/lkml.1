Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbYFXRgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbYFXRgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYFXRfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:35:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:24787 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbYFXRfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ao6wteAsqiwdf5Qq0gWbUJ5JFlew2VnbWmYPRJwbWHQMHnWLmNO4fLRqw6GJNhqM5N
         988ZZs6CxkX+RvlsgRgsxdQsyfXAfhmwmIwgZC3ZBkC5VYfYDyTY8CcaAXXb4rgwybfZ
         xe9xgT7OsnGfESUCex0YxitcuaAWNSOMvfu5U=
Message-ID: <2f11576a0806241035p45a440e1gb798091ef39cffc8@mail.gmail.com>
Date: Wed, 25 Jun 2008 02:35:51 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] fix to putback_lru_page()/unevictable page handling rework v3
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       "Rik van Riel" <riel@redhat.com>
In-Reply-To: <1214327987.6563.22.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080624184122.D838.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1214327987.6563.22.camel@lts-notebook>
X-Google-Sender-Auth: 78e0e719767ff0f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 'lru' was not being set to 'UNEVICTABLE when page was, in fact,
> unevictable [really "nonreclaimable" :-)], so retry would never
> happen, and culled pages never counted.
>
> Also, redundant mem_cgroup_move_lists()--one with incorrect 'lru',
> in the case of unevictable pages--messes up memcontroller tracking [I think].

indeed.
sorry, I forgot to send this fix.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

but I still happend panic on usex and nishimura-san's cpuset migration test.
  -> http://marc.info/?l=linux-mm&m=121375647720110&w=2


I'll  investigate it tommorow.
