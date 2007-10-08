Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbXJIH5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbXJIH5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 03:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbXJIH5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 03:57:08 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:32252 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753051AbXJIH5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 03:57:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GxYVAv2NQ1YsiD5LH5CarlpqfkVQGbSx957sWjboaXCfTf8IutzcnlqJRteCx6zMBEph3nEU0cwRd62pX6VXIAVY6n7ZL+Xl/3mXiQ83tTiDiNvtFC6Y95UROHE4Yh73dCSASwqeQonInBe7FaiNdOq41Qe9itZ1yQiR58UXWBw=  ;
X-YMail-OSG: 6nL8jc8VM1nHCEHRQt9pts_m3UtlbxLi3llQcxOdMJlKEuEbFd2gE.EJwRNOLPqQJ_c6o_dz4A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Huang, Ying" <ying.huang@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH -mm -v4 1/3] i386/x86_64 boot: setup data
Date: Tue, 9 Oct 2007 01:25:26 +1000
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1191912010.9719.18.camel@caritas-dev.intel.com>
In-Reply-To: <1191912010.9719.18.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710090125.27263.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 16:40, Huang, Ying wrote:

> +unsigned long copy_from_phys(void *to, unsigned long from_phys,
> +			     unsigned long n)
> +{
> +	struct page *page;
> +	void *from;
> +	unsigned long remain = n, offset, trunck;
> +
> +	while (remain) {
> +		page = pfn_to_page(from_phys >> PAGE_SHIFT);
> +		from = kmap_atomic(page, KM_USER0);
> +		offset = from_phys & ~PAGE_MASK;
> +		if (remain > PAGE_SIZE - offset)
> +			trunck = PAGE_SIZE - offset;
> +		else
> +			trunck = remain;
> +		memcpy(to, from + offset, trunck);
> +		kunmap_atomic(from, KM_USER0);
> +		to += trunck;
> +		from_phys += trunck;
> +		remain -= trunck;
> +	}
> +	return n;
> +}


I suppose that's not unreasonable to put in mm/memory.c, although
it's not really considered a problem to do this kind of stuff in
a low level arch file...

You have no kernel virtual mapping for the source data?

Should it be __init?

Care to add a line of documentation if you keep it in mm/memory.c?

Thanks,
Nick
