Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYL0GH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYL0GH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 01:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbYL0GHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 01:07:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56679 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYL0GHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 01:07:11 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] perf_counter: more barrier in blank weak function
Cc: kosaki.motohiro@jp.fujitsu.com, Sam Ravnborg <sam@ravnborg.org>,
       David Howells <dhowells@redhat.com>, mingo@elte.hu,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
In-Reply-To: <4955B782.3030407@kernel.org>
References: <20081226102716.GA31450@uranus.ravnborg.org> <4955B782.3030407@kernel.org>
Message-Id: <20081227150534.F472.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sat, 27 Dec 2008 15:07:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Impact: fix panic possible panic etc
> 
> some compiler seems to inline the weak global function if no line in it
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index d7a79f3..37f7716 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -45,8 +45,8 @@ hw_perf_counter_init(struct perf_counter *counter)
>  }
>  
>  u64 __weak hw_perf_save_disable(void)		{ return 0; }
> -void __weak hw_perf_restore(u64 ctrl)		{ }
> -void __weak hw_perf_counter_setup(void)		{ }
> +void __weak hw_perf_restore(u64 ctrl)		{ barrier(); }
> +void __weak hw_perf_counter_setup(void)		{ barrier(); }

We need comment into the function.
I expect anyone think "hm, this barrier() is meaningless. let's cleanup." in the future.
we should avoid it.



