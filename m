Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbXGCVZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbXGCVZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbXGCVZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:25:30 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:2620 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753888AbXGCVZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:25:29 -0400
Date: Tue, 3 Jul 2007 22:25:24 +0100 (BST)
From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
To: David Woodhouse <dwmw2@infradead.org>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Christoph Lameter <clameter@engr.sgi.com>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [PATCH] Re: Sparc32: random invalid instruction occourances on
 sparc32 (sun4c)
In-Reply-To: <1183490778.29081.35.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.61.0707032209230.30376@mtfhpc.demon.co.uk>
References: <468A7D14.1050505@googlemail.com>  <Pine.LNX.4.61.0707031817050.29930@mtfhpc.demon.co.uk>
  <Pine.LNX.4.61.0707031910280.29930@mtfhpc.demon.co.uk>
 <1183490778.29081.35.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

The problem is that sun4c Sparc32 can't handle un-aligned variables so 
having a 64bit readzone word that is not aligned on a 64bit boundary is a 
problem.

In addition, having looked at the size calculations, it looks to me as if 
not all of them got updated to handle 64bit redzone words. This may be part of 
the problem. By making BYTES_PER_WORD 64bit aligned (Sparc32) this is 
nolonger an issue.

Regards
 	Mark Fortescue.

On Tue, 3 Jul 2007, David Woodhouse wrote:

> On Tue, 2007-07-03 at 19:57 +0100, Mark Fortescue wrote:
>>> Commit b46b8f19c9cd435ecac4d9d12b39d78c137ecd66 partially fixed alignment
>>> issues but does not ensure that all 64bit alignment requirements of sparc32
>>> are met. Tests have shown that the redzone2 word can become misallignd.
>
> Oops, sorry about that. I'm not sure about your patch though -- I think
> I'd prefer to keep the redzone misaligned (and hence _right_ next to the
> real data), and just deal with it.
>
> typedef unsigned long long __aligned__((BYTES_PER_WORD)) redzone_t;
>
> -- 
> dwmw2
>
> -
> To unsubscribe from this list: send the line "unsubscribe sparclinux" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
