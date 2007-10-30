Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbXJ3P0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbXJ3P0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXJ3P0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:26:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:32339 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXJ3P0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jAt6h3rgHgfdxIevIL/g7EAMVGa0K3cbrZ1DL1EP+WP2zfEJK2xepdBF/CdgiNRAWvamz9MVI5jQODExQHvJOVrkORrYvP78QV1uAOCivFx3w2wSrfJZuznXmrjkLhd6DlLh0KUVabekPOuVmokAsx53UWPmBAbp2QqRS5ONiyA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Date: Tue, 30 Oct 2007 15:26:31 +0000
User-Agent: KMail/1.9.1
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
In-Reply-To: <1193173966-3550-1-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301526.31664.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 October 2007 22:12, Matthew Wilcox wrote:
> Consecutive calls to printk are non-atomic, which leads to various
> implementations for accumulating strings which can be printed in one call.
> This is a generic string buffer which can also be used for non-printk
> purposes.  There is no sb_scanf implementation yet as I haven't identified
> a user for it.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

> +static inline void sb_free(struct stringbuf *sb)
> +{
> +	if (sb->alloc > 0)
> +		kfree(sb->s);
> +	sb_init(sb);
> +}

> +static inline char *sb_to_string(struct stringbuf *sb)
> +{
> +	char *s = sb->s;
> +	if (sb_error(sb))
> +		s = kstrdup(s, GFP_ATOMIC);
> +	sb_init(sb);
> +	return s;
> +}

I am not sure inlining these functions is a win.
--
vda
