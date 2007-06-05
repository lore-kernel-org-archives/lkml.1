Return-Path: <linux-kernel-owner+w=401wt.eu-S932915AbXFEVFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbXFEVFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 17:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbXFEVFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 17:05:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:39908 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbXFEVFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 17:05:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xo9qmkUIqCLc47RG9LLkPSOSxkl9xd4DeJKU/FQ+WhAEK7eiJbsKdjquQuD3gJHKaZHbE+R3BhiXz/z89oQ2AgCTTSvepXA7wax4XdtaSeNz1JfjgoqjTE/CpjYxYg+6iQTIubNDVkUZKyAg3lqWyJqOTVRA2DCH2x4gWl8IlnE=
Message-ID: <a781481a0706051405n5af19f2t52bd1760f216fd59@mail.gmail.com>
Date: Wed, 6 Jun 2007 02:35:39 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] S390: Replace calls to __get_free_pages() with __get_dma_pages().
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com, "Andrew Morton" <akpm@osdl.org>,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0706051650110.19661@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706051650110.19661@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/6/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
> Replace a number of calls to __get_free_pages() with the corresponding
> calls to __get_dma_pages().
> [...]
>   once the __GFP_DMA argument is removed, it does look weird to see
> the first argument of just 0.  should that be filled in with
> GFP_ATOMIC as christopher lameter suggested?

Yes, I suppose so ... GFP_ATOMIC can dip into the emergency
pools so would also make this code a bit more "robust" than using
"0" (== GFP_NOWAIT) and it's not that GFP_ATOMIC "waits" on
anything either ...

> -                       (void *)__get_free_pages(__GFP_DMA,
> +                       (void *)__get_dma_pages(0,

GFP_NOWAIT == 0, so the macro GFP_NOWAIT is the one to
use if you really don't want any change in behaviour (and as the
comment above GFP_NOWAIT says, it's much better to use that
name than simply specify "0").

Off-topic, but I wonder what are the valid usage cases / scenarios
for GFP_NOWAIT? The obvious answer is somebody might want to
be a way-too-polite citizen and stay off the emergency pools even
from atomic context, but why would anybody want to do /that/ ...
[ BTW there are 3 users of GFP_NOWAIT in kernel code, but there
could be more that simply specify "0" to get same behaviour. ]

Satyam
