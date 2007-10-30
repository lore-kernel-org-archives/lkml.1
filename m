Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbXJ3BWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbXJ3BWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 21:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbXJ3BW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 21:22:29 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:53088 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbXJ3BW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 21:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gbRXzUkbBQFUGNq1qosQ91lCP4SFx19AukqseT+tZaSbNwwQzgE19Wp+K0EhXX4J2+luWoNJ2gYiYgbZpqV3oOLtoW1/MMtEffM1YJXOhRfS8Qrh4lyS20x0C8tdhCUGiJnFGZHkFKkCzUXoLuwwnrBri6etmuG2Vx8eWv31TBk=
Message-ID: <45a44e480710291822w5864b3beofcf432930d3e68d3@mail.gmail.com>
Date: Mon, 29 Oct 2007 21:22:26 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: vm_ops.page_mkwrite() fails with vmalloc on 2.6.23
Cc: "Andrew Morton" <akpm@linux-foundation.org>, stefani@seibold.net,
       linux-kernel@vger.kernel.org, "David Howells" <dhowells@redhat.com>,
       linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <1193696211.5644.100.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193064057.16541.1.camel@matrix>
	 <20071029004002.60c7182a.akpm@linux-foundation.org>
	 <45a44e480710290117u492dbe82ra6344baf8bb1e370@mail.gmail.com>
	 <1193677302.27652.56.camel@twins>
	 <45a44e480710291051s7ffbb582x64ea9524c197b48a@mail.gmail.com>
	 <1193681839.27652.60.camel@twins> <1193696211.5644.100.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> [ also, remap_vmalloc_range() suffers similar issues, only file and anon
>   have proper rmap ]
>
> I'm not sure we want full rmap for remap_pfn/vmalloc_range, but perhaps
> we could assist drivers in maintaining and using vma lists.
>
> I think page_mkclean_one() would work if you'd manually set page->index
> and iterate the vmas yourself. Although atm I'm not sure of anything so
> don't pin me on it.

:-) If it's anybody's fault, it's mine for not testing properly. My bad.

In the case of defio, I think it's no trouble to build a list of vmas
at mmap time and then to iterate through them when it's ready for
mkclean time as you suggested. I don't fully understand page->index
yet. I had thought it was only used by swap cache or file map.

On an unrelated note, I was looking for somewhere to stuff a 16 bit
offset (so that I have a cheap way to know which struct page
corresponds to which framebuffer block or offset) for another driver.
I had thought page->index was it but I think I am wrong now.

Thanks,
jaya
