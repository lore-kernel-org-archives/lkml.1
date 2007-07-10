Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbXGJU6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbXGJU6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 16:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbXGJU6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 16:58:37 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:25696 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145AbXGJU6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 16:58:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AgpCh48eV9DQKmbML2bAdhLRMWkY3MCeNNYaBUw2tXIYgpjVjdWq4j+XSTwyyJe+RRW2SqCFZUoMQXQ08jya/Pu9RzPJD9yunSJxLK1CwdY2aj9+ebbLSLxHm5y39S3poRkHHdXlxn+BukSGO1SdpkVeFVHU5v/vqH932OIuHWs=
Message-ID: <4693F242.2030004@gmail.com>
Date: Tue, 10 Jul 2007 15:55:30 -0500
From: William Tambe <tambewilliam@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Stas Sergeev <stsp@aknet.ru>,
       "Rohland, Hans-Christoph" <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
References: <468562F6.4010604@gmail.com> <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com> <46893F97.7080200@aknet.ru> <Pine.LNX.4.64.0707031606370.16965@blonde.wat.veritas.com> <4692E5DF.7080304@gmail.com> <Pine.LNX.4.64.0707102056140.4107@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0707102056140.4107@blonde.wat.veritas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Hugh Dickins wrote:
> On Mon, 9 Jul 2007, William Tambe wrote:
>> Hugh Dickins wrote:
>>> I've come right around to your original view, Stas, and William's:
>>> if that mmap creates such an object, then the expanding mremap really
>>> ought to be useful, and allow the underlying object to be expanded.
>>> The shared anonymous object is already anomalous: expanding it on
>>> fault makes it more consistent with its own nature, not less.
>>> ...
>>> Here's a patch against 2.6.22-rc7: would you, Stas, put your
>>> Signed-off-by into this, and accept authorship - although I'm
>>> sending this back to you, it's very much your idea, and only
>>> trivially modified from your three-year-old patch by me.  If
>>> you're agreeable, I can then forward it or its shmem_zero_fault
>>> equivalent to Andrew when we see which way 2.6.23 is going.
>> ... 
>> Will this patch be added to stable versions of the linux kernel?
>> Please let me know.
> 
> I confess that the lukewarm response from Stas cooled my enthusiasm,
> and left me feeling that perhaps I'm an idiot to be adding such a
> feature so many years too late; and my old caution about the way
> a child could use up memory not freed on child's exit, unknown to
> parent, returned to haunt me.  That could be documented for new
> usages, but I just don't know what usages are already out there,
> and fear I'd be introducing an exploit.
> 
> It most certainly will not be added to a stable version of the
> linux kernel, if by that you mean 2.6.22.N or 2.6.21.N etc.
> Though it can be viewed as a bugfix, the patch as it stands
> seems in danger of introducing its own bug, and it's just too
> much of a feature to be suitable for a -stable release.
> 
> But more probably you meant, will it be in 2.6.23 or 2.6.24?
> Sorry to be such a vacillatiing wimp, but I don't know.
> How well are you managing with the shm_open approach?
> 
> Hugh
> 

I understand your concern. But since I am working on a dynamic memory 
management code that I wish to use with other projects that I have, I 
didn't find appropriate to use shm_open.

In fact there is a name associated with the shared memory requested with 
shm_open, so that it can be mmap(ed) in another process. And I do not 
wish to have it accessible by any other process, unless I choose to do so.

shm_open is great, but it doesn't quite fit my needs.
And I think remap(ing) ANONYMOUS memory kind of make a lot of things easier.

Can that feature be added at least to release candidates series so that 
everybody can try it and see how well it does?

Sincerely,
William Tambe
