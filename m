Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZHUHmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZHUHmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 03:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZHUHmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 03:42:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38245 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbZHUHmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 03:42:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 Aug 2009 16:40:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kcore-use-registerd-physmem-information-fix2
Message-Id: <20090821164016.4fd3d1a1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1250840168-4614-1-git-send-email-jirislaby@gmail.com>
References: <1250840168-4614-1-git-send-email-jirislaby@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 09:36:08 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Fix this compilation warning on x86_64:
> fs/proc/kcore.c: In function ‘kclist_add_private’:
> fs/proc/kcore.c:175: warning: comparison between pointer and integer
> 
Oh, thank you.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  fs/proc/kcore.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
> index aabbc3a..98fcf17 100644
> --- a/fs/proc/kcore.c
> +++ b/fs/proc/kcore.c
> @@ -172,7 +172,7 @@ kclist_add_private(unsigned long pfn, unsigned long nr_pages, void *arg)
>  		ent->size = ULONG_MAX - ent->addr;
>  
>  	/* cut when vmalloc() area is higher than direct-map area */
> -	if (VMALLOC_START > __va(0)) {
> +	if (VMALLOC_START > (unsigned long)__va(0)) {
>  		if (ent->addr > VMALLOC_START)
>  			goto free_out;
>  		if (VMALLOC_START - ent->addr < ent->size)
> -- 
> 1.6.3.3
> 
> 

