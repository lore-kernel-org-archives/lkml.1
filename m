Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYDPSgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYDPSgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYDPSf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:35:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbYDPSf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:35:57 -0400
Message-ID: <480646B2.9000905@redhat.com>
Date: Wed, 16 Apr 2008 14:34:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Tom Zanussi <zanussi@comcast.net>, David Wilder <dwilder@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, tzanussi@gmail.com
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer take 2
References: <4804C95F.2080204@redhat.com> <1208319769.7893.16.camel@charm-linux> <48063F80.9060404@redhat.com> <Pine.LNX.4.64.0804162110070.19171@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0804162110070.19171@sbz-30.cs.Helsinki.FI>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Pekka J Enberg wrote:
> Hi Masami,
> 
> On Wed, 16 Apr 2008, Masami Hiramatsu wrote:
>> +static struct page *relay_alloc_page_array(unsigned int n_pages)
>> +{
>> +	struct page *array;
>> +	unsigned int pa_size = n_pages * sizeof(struct page *);
>> +
>> +	if (pa_size > PAGE_SIZE) {
>> +		array = vmalloc(pa_size);
>> +		if (array)
>> +			memset(array, 0, pa_size);
>> +	} else {
>> +		array = kcalloc(n_pages, sizeof(struct page *), GFP_KERNEL);
>> +	}
>> +	return array;
>> +}
> 
> I think it's bit confusing to have relay_alloc_page_array() return a 
> pointer to struct page as it's really allocating an _array_ of pointers to 
> struct page. So why not just use void * here as the kernel memory 
> allocators do?

Thank you very much, it was my mistake.
It should return struct page **.

>> +static void relay_free_page_array(struct page *array)
>> +{
>> +	if (is_vmalloc_addr(array))
>> +		vfree(array);
>> +	else
>> +		kfree(array);
>> +}
> 
> Here as well.

Thanks,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

