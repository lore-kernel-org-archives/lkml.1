Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbZE1Hl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbZE1Hl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZE1Hlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:41:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411AbZE1Hlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:41:49 -0400
Date: Thu, 28 May 2009 00:41:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Patch] kbuild: fix a compile warning
Message-Id: <20090528004100.3716e00d.akpm@linux-foundation.org>
In-Reply-To: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>
References: <20090515075229.11346.6710.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 03:51:18 -0400 Amerigo Wang <amwang@redhat.com> wrote:

> 
> I got this warning:

With which gcc version?

>  HOSTCC  scripts/basic/fixdep
> scripts/basic/fixdep.c: In function 'traps':
> scripts/basic/fixdep.c:377: warning: dereferencing type-punned pointer will break strict-aliasing rules
> scripts/basic/fixdep.c:379: warning: dereferencing type-punned pointer will break strict-aliasing rules
> 

(wtf?)

> 
> --- a/scripts/basic/fixdep.c
> +++ b/scripts/basic/fixdep.c
> @@ -373,10 +373,11 @@ void print_deps(void)
>  void traps(void)
>  {
>  	static char test[] __attribute__((aligned(sizeof(int)))) = "CONF";
> +	int *p = (int *)test;
>  
> -	if (*(int *)test != INT_CONF) {
> +	if (*p != INT_CONF) {
>  		fprintf(stderr, "fixdep: sizeof(int) != 4 or wrong endianess? %#x\n",
> -			*(int *)test);
> +			*p);
>  		exit(2);
>  	}
>  }
