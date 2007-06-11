Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbXFKRx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbXFKRx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXFKRxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:53:22 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:34738 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbXFKRxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:53:21 -0400
Message-ID: <466D8B0F.3080608@gmail.com>
Date: Mon, 11 Jun 2007 19:49:03 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky> <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com>
In-Reply-To: <20070611172006.GI9174@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2007 07:20 PM, Dave Jones wrote:

> FWIW, waay back when (sometime last year if memory serves)
> Linus suggested changing the default to 0x1000000 for all x86.
> The reasoning was some performance microoptimisation regarding
> 4MB aligned TLBs iirc.

Yup. Or rather, he suggested 4M (0x400000):

http://lkml.org/lkml/2006/2/23/189

Aligning the kernel image on 4M could gain an additional TLB entry if the 
kernel image would fit in one (4M aligned) hugepage, but not in the 3M 
that's left after loading the kernel at 1M physical. And that stuff about 
the MTRRs...

That 0x1000000 (16M) is another potentially interesting value on machines 
with enough memory as it gets the kernel image out of the old ZONE_DMA.

> The details have long since evaded my memory, but as an experiment,
> I made the change to the Fedora kernel.  FC5,FC6 and F7 have been
> this way for a while now, with no obvious problems. Ditto RHEL5.
> We did get some performance numbers at the time of the change,
> but they weren't amazing (basically in the noise).
> Given it never seemed to actually get worse, I never got around
> to reverting it..

I've been loading the kernel at 16M physical for ages now on x86. No 
problems either.

Rene.

