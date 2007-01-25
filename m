Return-Path: <linux-kernel-owner+w=401wt.eu-S965551AbXAYGfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965551AbXAYGfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 01:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965546AbXAYGfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 01:35:30 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:3902 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965551AbXAYGfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 01:35:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D1CWP+DCNC2CFkmVJT+tNldbvwYuJYjkojQE6CCvQi1ktQ8ntCf/4myof+X7nh8q6rlVKy1HW41PlKTsxMBqhadyHZ7hTq28c5F4ICJgPx2US2kOOEPRDYBJnVNjWBzqpPYQwp2F8jc1U6SI9knFRscAND3MHYs7v5jBHe0/VQw=
Message-ID: <6d6a94c50701242235m48013856kb5a947c489d9da37@mail.gmail.com>
Date: Thu, 25 Jan 2007 14:35:29 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC] Limit the size of the pagecache
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <45B82F41.9040705@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
	 <45B75208.90208@linux.vnet.ibm.com>
	 <Pine.LNX.4.64.0701240655400.9696@schroedinger.engr.sgi.com>
	 <45B82F41.9040705@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
>
>
> Christoph Lameter wrote:
> > On Wed, 24 Jan 2007, Vaidyanathan Srinivasan wrote:
> >
> >> With your patch, MMAP of a file that will cross the pagecache limit hangs the
> >> system.  As I mentioned in my previous mail, without subtracting the
> >> NR_FILE_MAPPED, the reclaim will infinitely try and fail.
> >
> > Well mapped pages are still pagecache pages.
> >
>
> Yes, but they can be classified under a process RSS pages.  Whether it
> is an anon page or shared mem or mmap of pagecache, it would show up
> under RSS.  Those pages can be limited by RSS limiter similar to the
> one we are discussing in pagecache limiter.  In my opinion, once a
> file page is mapped by the process, then it should be treated at par
> with anon pages.  Application programs generally do not mmap a file
> page if the reuse for the content is very low.
>

I agree, we shouldn't take mmapped page into account.
But Vaidy - even with your patch, we are still using the existing
reclaimer, that means we dont ensure that only page cache is
reclaimed/limited. mapped pages will be hit also.
I think we still need to add a new scancontrol field to lock mmaped
pages and remove unmapped pagecache pages only.

-Aubrey
