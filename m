Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbYGYUbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbYGYUbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYGYUbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:31:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:31417 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbYGYUba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FTFiR3HxyVry0RecmXAQcWm67DDiQziXTAFmmkAPejqeUD9kb+URr/imcyexiD9FG7
         l/2i1JdNhFM1kmglp+TAqZmp7kGMUra2tSOn1eRfun4xjiKE46jBscmV4vJUmBONFUI8
         LJ3oMX+g9HqMJ02RBmpeWhvWk4O2fX01X0qEo=
Message-ID: <29495f1d0807251331j2f600321u6edf58282047614a@mail.gmail.com>
Date: Fri, 25 Jul 2008 13:31:29 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] mm/hugetlb.c: fix build failure
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080725183549.GA23562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080725105741.GA24336@elte.hu> <20080725183549.GA23562@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/08, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Ingo Molnar <mingo@elte.hu> wrote:
>
>  > on !CONFIG_SYSCTL on x86 with latest -git i get:
>  >
>  >      mm/hugetlb.c: In function 'decrement_hugepage_resv_vma':
>  >      mm/hugetlb.c:83: error: 'reserve' undeclared (first use in this function)
>  >      mm/hugetlb.c:83: error: (Each undeclared identifier is reported only once
>  >      mm/hugetlb.c:83: error: for each function it appears in.)
>
>
> the above build error came from a bisection run, the fix i sent was for
>  this build error:
>
>   mm/hugetlb.c: In function 'hugetlb_acct_memory': mm/hugetlb.c:1507:
>   error: implicit declaration of function 'cpuset_mems_nr'
>
>  but i also get a second hugetlb build failure on 64-bit x86:
>
>   arch/x86/mm/built-in.o: In function `setup_hugepagesz':
>   hugetlbpage.c:(.init.text+0xb49): undefined reference to `hugetlb_add_hstate'
>
>  fixed by the patch below.

Both issues (I expect) will be fixed by:
http://marc.info/?l=linux-kernel&m=121700986003238&w=2. Could you
test?

Thanks,
Nish
