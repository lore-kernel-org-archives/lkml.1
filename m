Return-Path: <linux-kernel-owner+w=401wt.eu-S1764736AbXINDhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764736AbXINDhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 23:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbXINDhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 23:37:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13333 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbXINDhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 23:37:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=jegHiHaRIxSb/YOPcC/T5SlvUJuSXVISyOM7OMMK3Ak5A9NOatIrrh4+v7SZtU3to
	GmcRjbYq4bKPhc5n5dTew==
Date: Thu, 13 Sep 2007 20:36:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] [-mm patch]  Add nodemask_t's size and NR_FREE_PAGES's
 value to vmcoreinfo_data.
In-Reply-To: <46E9F854.9030804@mxs.nes.nec.co.jp>
Message-ID: <alpine.DEB.0.9999.0709132034540.30494@chino.kir.corp.google.com>
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp> <46E9F854.9030804@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2007, Ken'ichi Ohmichi wrote:

> diff -rpuN a/include/linux/kexec.h b/include/linux/kexec.h
> --- a/include/linux/kexec.h	2007-09-10 23:28:42.000000000 +0900
> +++ b/include/linux/kexec.h	2007-09-10 23:29:52.000000000 +0900
> @@ -132,11 +132,16 @@ unsigned long paddr_vmcoreinfo_note(void
>  #define SIZE(name) \
>  	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
>  			      (unsigned long)sizeof(struct name))
> +#define TYPEDEF_SIZE(name) \
> +	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
> +			      (unsigned long)sizeof(name))
>   #define OFFSET(name, field) \
>  	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
>  			      (unsigned long)&(((struct name *)0)->field))
>  #define LENGTH(name, value) \
>  	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
> +#define NUMBER(name) \
> +	vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
>  #define CONFIG(name) \
>  	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
> 

The #define SIZE() should be renamed STRUCT_SIZE() since it's always 
returning the size of the struct with a given name.  This would allow 
TYPEDEF_SIZE() to simply become SIZE() since it need not be used 
exclusively for typedefs.
