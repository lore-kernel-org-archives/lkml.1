Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYHBCvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYHBCvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYHBCvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:51:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56679 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbYHBCvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:51:38 -0400
Message-ID: <4893CBA9.9020008@cn.fujitsu.com>
Date: Sat, 02 Aug 2008 10:51:21 +0800
From: Yu Zhiguo <yuzg@cn.fujitsu.com>
User-Agent: Thunderbird 1.5.0.7 (Windows/20060909)
MIME-Version: 1.0
To: zhangxiliang <zhangxiliang@cn.fujitsu.com>
CC: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
       viro@zeniv.linux.org.uk, Linux Audit <linux-audit@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the kernel panic of audit_filter_task when key field
 is set
References: <4892F063.1080109@cn.fujitsu.com> <4893C42A.60803@cn.fujitsu.com>
In-Reply-To: <4893C42A.60803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


zhangxiliang wrote:

>  static int audit_match_perm(struct audit_context *ctx, int mask)
>  {
> +	if(!ctx)
> +		return 0;
>  	unsigned n = ctx->major;

Please check this patch with scripts/checkpatch.pl and then resend it.


>  	switch (audit_classify_syscall(ctx->arch, n)) {
>  	case 0:	/* native */
> @@ -284,6 +286,8 @@ static int audit_match_filetype(struct audit_context *ctx, int which)
>  {
>  	unsigned index = which & ~S_IFMT;
>  	mode_t mode = which & S_IFMT;
> +	if(!ctx)
> +		return 0;
>  	if (index >= ctx->name_count)
>  		return 0;
>  	if (ctx->names[index].ino == -1)
> 
> 

