Return-Path: <linux-kernel-owner+w=401wt.eu-S1751600AbXC3No0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbXC3No0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbXC3No0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:44:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:26841 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXC3NoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GwuVc9JsjLfpLV7ri/r0QF9oGK50160dXWS/rHJUlzl2+/RmntjUjoHHHmaH0xNuv7fz4sFFd2hGudr6d70Ky638kiHMzRGAueEV4/3DB1hr60jBLFIjPKM5YOI2KcQxFJV3IxnZNBFYue9EpXJDVsFIGIWWITwiQbUYe/Gsxac=
Message-ID: <6d6a94c50703300644y28e51f47h19182f550c18c40d@mail.gmail.com>
Date: Fri, 30 Mar 2007 21:44:24 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding UNINITIALIZE flag
Cc: vapier.adi@gmail.com, jie.zhang@analog.com, bryan.wu@analog.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <15938.1175253862@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1175226172.15391.66.camel@roc-desktop>
	 <10785.1175247540@redhat.com>
	 <6d6a94c50703300334w6b4787f3p144715de5166d7bc@mail.gmail.com>
	 <15938.1175253862@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/07, David Howells <dhowells@redhat.com> wrote:
> Aubrey Li <aubreylee@gmail.com> wrote:
>
> > malloc() allocates size bytes and returns a pointer to the allocated memory.
> > ****The memory is not cleared.****
>
> But this is *not* malloc().  It's mmap().  Are you prepared to guarantee that
> there are no applications out there that don't rely on anon mmap() giving
> zeroed memory?

I can't find mmap must give zeroed memory in the mmap manual.
Is there any reason relying on anon mmap() giving zerod memory?
Can you show me an example?

>
> The MMU-mode clearing is done for security reasons - there shouldn't be any
> leakage between processes, and because the zero page can just be faulted in.
>
NO-MMU can't do this clearing. Performance is down.

> Personally, I'd prefer to maintain compatibility with MMU-mode wherever
> possible, but I'm happy with overrides like the MAP_UNINITIALISED flag
> suggested.
>
Not necessary IMHO.

-Aubrey
