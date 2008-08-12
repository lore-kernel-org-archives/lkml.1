Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYHLMwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYHLMwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYHLMwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:52:24 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:57681 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYHLMwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:52:23 -0400
Message-ID: <48A1880E.7000401@gmail.com>
Date: Tue, 12 Aug 2008 16:54:38 +0400
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Ryan Hope <rmh3093@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs mailing list <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3][reiser4] don't leave loop prematurely
References: <48A0BF59.4050605@gmail.com>
In-Reply-To: <48A0BF59.4050605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Hope wrote:
> This was item #9 on the todo list for reiser4 inclusion in mainline:
>
> diff --git
> a/52d76fde71070a6c4c8c581dd2bfe3c6ffa82ad7:fs/reiser4/page_cache.c
> b/7f1ee1bb0c5a2948f5347646795afd088da30eaf:fs/reiser4/page_cache.c
> index
> edf0911dc8bb61398374ecf4f849aa30753fb274..fe713681b73d2a6c4214f5938f21794573d8607d
> 100644
> --- a/52d76fde71070a6c4c8c581dd2bfe3c6ffa82ad7:fs/reiser4/page_cache.c
> +++ b/7f1ee1bb0c5a2948f5347646795afd088da30eaf:fs/reiser4/page_cache.c
> @@ -658,8 +658,7 @@ truncate_jnodes_range(struct inode *inode, pgoff_t
> from, pgoff_t count)
>                  unhash_unformatted_jnode(node);
>                  truncated_jnodes++;
>                  jput(node);
> -            } else
> -                break;
> +            }

No, this is wrong:
if (node == NULL), then there is nothing to do in this loop.

Edward.

>          }
>          if (i != taken || taken == 0)
>              break;
>
>
> -Ryan
>

