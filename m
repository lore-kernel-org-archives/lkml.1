Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbYHTMiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbYHTMiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYHTMiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:38:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:12611 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbYHTMiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:38:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=Abwezqsm0Q5t4EHJz3pQMzgub+k6ar3XNbJqWzaoEqLY1YyuTa1bCZM26/Knu6UQGA
         9UnOGrcry/vp3PqYr3Kwf1uo7Y9L5XVycH/NAEDKEQW4R37Fgo+HDjyAcYa0aZFLYS1i
         5gcvuwveX8LiUYn0WK49bxJCRjSwxqljTMixA=
Date: Wed, 20 Aug 2008 16:39:29 +0400
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Message-ID: <20080820123929.GA29972@x200.localdomain>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <200808181109.43203.rusty@rustcorp.com.au> <20080818075459.GH30694@elte.hu> <48A9472F.908@panasas.com> <20080819133422.GA24369@elte.hu> <48AAF5F7.6040709@panasas.com> <20080820105922.GC18524@elte.hu> <48AC0EB9.3080708@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AC0EB9.3080708@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: adobriyan@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 03:31:53PM +0300, Boaz Harrosh wrote:
> Ingo Molnar wrote:
> > * Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> If the user of virtio_has_feature() must pass a compile-time constant 
> >> then it must be converted to a MACRO, and then the BUILD_BUG_ON will 
> >> work. Or it should be changed to a BUG_ON() if fbit is a runtime 
> >> variable.
> > 
> 
> The use of __builtin_constant_p in inline functions is broken. This
> is because it will give different results depending on the -O level
> used. So I think that using it in the Kernel with inlines is plain
> broken. And should be discouraged.

See how kmalloc() works.

