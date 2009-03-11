Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZCKKdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZCKKdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZCKKdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:33:22 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:40988 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbZCKKdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YP40pxIdGKosIusaZ9+5JYb0ZUxe7E8Avyp34DlL3emHBX0aJzKQibaib9CtxFfUfE
         +YGaG4gl/P6PZUPDN38gtMGAJhWDq21FFkinp1lA1SN4P76mzc2iSvzIcbH11eS4/6Lp
         ms2sqgMlTt+bIQDyaLfgiIBeRKte+zW4cty3w=
Date: Wed, 11 Mar 2009 13:40:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Daniel Lowengrub <lowdanie@gmail.com>
Cc: linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: use list.h for vma list
Message-ID: <20090311104018.GA2376@x200.localdomain>
References: <8c5a844a0903110255q45b7cdf4u1453ce40d495ee2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c5a844a0903110255q45b7cdf4u1453ce40d495ee2c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 11:55:48AM +0200, Daniel Lowengrub wrote:
> Use the linked list defined list.h for the list of vmas that's stored
> in the mm_struct structure.  Wrapper functions "vma_next" and
> "vma_prev" are also implemented.  Functions that operate on more than
> one vma are now given a list of vmas as input.

> Signed-off-by: Daniel Lowengrub

That's not how S-o-b line should look like.

> --- linux-2.6.28.7.vanilla/arch/alpha/kernel/osf_sys.c
> +++ linux-2.6.28.7/arch/alpha/kernel/osf_sys.c
> @@ -1197,7 +1197,7 @@
>  		if (!vma || addr + len <= vma->vm_start)
>  			return addr;
>  		addr = vma->vm_end;
> -		vma = vma->vm_next;
> +		vma = vma_next(vma);

Well, this bloats both mm_struct and vm_area_struct.
