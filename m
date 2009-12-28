Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbZL1K6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbZL1K6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZL1K6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:58:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:46564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZL1K6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:58:46 -0500
Subject: Re: [PATCH] perf lock: Implement basic sorting function of perf
 lock
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 11:58:18 +0100
Message-ID: <1261997898.7135.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 11:56 +0900, Hitoshi Mitake wrote:
> +#define SINGLE_KEY(member)                                     \
> +       static int lock_stat_key_ ## member(struct lock_stat *one,      \
> +                                        struct lock_stat *two)         \
> +       {                                                               \
> +       if (one->member > two->member)                                  \
> +               return 1;                                               \
> +       else                                                            \
> +               return 0;                                               \
> +       } 

Seems to me:

	return one->member > two->member;

Should suffice, no?

[ I usually call the arguments to a comparator (l)eft/(r)ight or a/b,
  but I guess one/two works too :-) ]

