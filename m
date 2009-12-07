Return-Path: <linux-kernel-owner+w=401wt.eu-S1751207AbZLGFTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbZLGFTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZLGFTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:19:07 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:41413 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZLGFTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:19:06 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf_event: fix __dsos__write_buildid_table()
References: <4B1C7EE1.8030906@cn.fujitsu.com>
	<4B1C7F45.5080105@cn.fujitsu.com> <4B1C7F73.80707@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 14:19:06 +0900
In-Reply-To: <4B1C7F73.80707@cn.fujitsu.com> (Xiao Guangrong's message of
	"Mon, 07 Dec 2009 12:07:15 +0800")
Message-ID: <87r5r74b05.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> writes:

> The remain buff size is 'len - pos->long_name_len - 1', not
> 'len - pos->long_name_len + 1'
>
> This bug is imported by:
> Commit-ID:  7691b1ec2e4a8d4bd88dcf88b29792399ebe1c91
> Gitweb:     http://git.kernel.org/tip/7691b1ec2e4a8d4bd88dcf88b29792399ebe1c91
> Author:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> AuthorDate: Sun, 6 Dec 2009 20:10:49 +0900
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 6 Dec 2009 18:15:02 +0100
>
> perf tools: Misc small fixes

Oops, I forgot parens. Thanks for fixing it.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  tools/perf/util/header.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 08b6759..59a9c0b 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -209,7 +209,7 @@ static int __dsos__write_buildid_table(struct list_head *head, int fd)
>  		err = do_write(fd, pos->long_name, pos->long_name_len + 1);
>  		if (err < 0)
>  			return err;
> -		err = do_write(fd, zero_buf, len - pos->long_name_len + 1);
> +		err = do_write(fd, zero_buf, len - pos->long_name_len - 1);
>  		if (err < 0)
>  			return err;
>  	}

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
