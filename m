Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZCZSNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZCZSNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZCZSNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:13:33 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:62093 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZCZSNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=g9Y7DJ1pfVoVABbaAdDTjJ8hyBLZciHhzBBEoUtXfC1K6khwPcMpJ7SZ/vOAD/wD7r
         hr9IjSboKuK1Xg+XXcK9V98gCpSYCIiglC7DKFjoswpDhEC9N0B43zLKTVD8ykTH03wl
         DxGWQz2UiSHuA45ByNE2K+8R+wxzwU32MZPyM=
Date: Thu, 26 Mar 2009 20:13:24 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: advance readpos in trace_seq_to_user() by
 really read bytes
Message-ID: <20090326201324.7952c874@daedalus.pq.iki.fi>
In-Reply-To: <87zlf8kxmd.wl%vmayatsk@redhat.com>
References: <87zlf8kxmd.wl%vmayatsk@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 18:22:18 +0100
Vitaly Mayatskikh <v.mayatskih@gmail.com> wrote:

> If tracer will not provide input buffer of enough size, he will never
> see data between cnt and len bytes.
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 17bb88d..0217615 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -477,7 +477,7 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
>  	if (ret)
>  		return -EFAULT;
>  
> -	s->readpos += len;
> +	s->readpos += cnt;
>  	return cnt;
>  }

This fix seems to be already included in tip/master:
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

It's not in Linus' master, but I guess it's on its way there.

Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
