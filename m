Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbYBAMjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbYBAMjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbYBAMjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:39:41 -0500
Received: from mx1.suse.de ([195.135.220.2]:38095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbYBAMjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:39:40 -0500
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make loglevel related commandline to early_param
From: Andi Kleen <andi@firstfloor.org>
References: <200802010240.37799.yinghai.lu@sun.com>
Date: Fri, 01 Feb 2008 13:39:39 +0100
In-Reply-To: <200802010240.37799.yinghai.lu@sun.com> (Yinghai Lu's message of "Fri\, 01 Feb 2008 02\:40\:37 -0800")
Message-ID: <p73bq704zqs.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <Yinghai.Lu@Sun.COM> writes:

> diff --git a/init/main.c b/init/main.c
> index cb81ed1..a774a93 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -232,22 +232,18 @@ EXPORT_SYMBOL(loops_per_jiffy);
>  
>  static int __init debug_kernel(char *str)
>  {
> -	if (*str)
> -		return 0;
>  	console_loglevel = 10;
>  	return 1;

The return semantics changes with early_param so you need to change that in all cases to return 0
(and negative value for errors) 

-Andi
