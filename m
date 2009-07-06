Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZGFMR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZGFMR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZGFMRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:17:52 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:11921 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbZGFMRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:17:51 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/2] perfcounter: Ignore the nmi call frames in the
 x86-64 backtraces
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1246474930-6088-1-git-send-email-fweisbec@gmail.com>
References: <1246474930-6088-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 14:17:48 +0200
Message-Id: <1246882668.8143.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 21:02 +0200, Frederic Weisbecker wrote:

> +int x86_is_stack_id(int id, char *name)
> +{
> +	return x86_stack_ids[id - 1] == name;
> +}

OK, this bit would need a bit of a comment explaining why this works, as
I don't think the C language guarantees de-duplication of constant
strings.

Therefore the above only works correctly if its passed a pointer from
the x86_stack_ids[] array -- as it indeed is, since the string passed is
obtained through the below method:

> +static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
> +					unsigned *usedp, char **idp)
> +{
>  	unsigned k;
>  
>  	/*
> @@ -61,7 +68,7 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
>  			if (*usedp & (1U << k))
>  				break;
>  			*usedp |= 1U << k;
> -			*idp = ids[k];
> +			*idp = x86_stack_ids[k];
>  			return (unsigned long *)end;
>  		}
>  		/*


