Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbYDPSVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbYDPSVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYDPSVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:21:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43814 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbYDPSVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:21:11 -0400
Date: Wed, 16 Apr 2008 21:21:09 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Tom Zanussi <zanussi@comcast.net>, David Wilder <dwilder@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, tzanussi@gmail.com
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer take 2
In-Reply-To: <48063F80.9060404@redhat.com>
Message-ID: <Pine.LNX.4.64.0804162110070.19171@sbz-30.cs.Helsinki.FI>
References: <4804C95F.2080204@redhat.com> <1208319769.7893.16.camel@charm-linux>
 <48063F80.9060404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Wed, 16 Apr 2008, Masami Hiramatsu wrote:
> +static struct page *relay_alloc_page_array(unsigned int n_pages)
> +{
> +	struct page *array;
> +	unsigned int pa_size = n_pages * sizeof(struct page *);
> +
> +	if (pa_size > PAGE_SIZE) {
> +		array = vmalloc(pa_size);
> +		if (array)
> +			memset(array, 0, pa_size);
> +	} else {
> +		array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
> +	}
> +	return array;
> +}

I think it's bit confusing to have relay_alloc_page_array() return a 
pointer to struct page as it's really allocating an _array_ of pointers to 
struct page. So why not just use void * here as the kernel memory 
allocators do?

> +static void relay_free_page_array(struct page *array)
> +{
> +	if (is_vmalloc_addr(array))
> +		vfree(array);
> +	else
> +		kfree(array);
> +}

Here as well.
