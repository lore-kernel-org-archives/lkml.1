Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbYDKPTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbYDKPTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760691AbYDKPT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:19:28 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:58316 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759777AbYDKPT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tezWMtkvhGNfm4vKfyHaFvxEnZgJHVylDfE2GSCrKLHVmO9N9oIAqBV0yWnasAFH+ayDN46zSHqzgCyvRyTVdVa2a+ddRWoAQOZm53yuyF5axk96myexzMEau0IBmzxTu5hSt1rn8FfDfBysN+gA3sGFzjwol9+PaGPx7LwCzAc=
Subject: Re: [PATCH 2/2] kernel: Move arches to use common unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <15208.1207908688@redhat.com>
References: <1207885132.22001.85.camel@brick>  <15208.1207908688@redhat.com>
Content-Type: text/plain
Date: Fri, 11 Apr 2008 08:19:26 -0700
Message-Id: <1207927166.22001.91.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 11:11 +0100, David Howells wrote:
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > -#ifndef _ASM_UNALIGNED_H
> > -#define _ASM_UNALIGNED_H
> > -
> > +#ifndef _ASM_FRV_UNALIGNED_H_
> > +#define _ASM_FRV_UNALIGNED_H_
> 
> Why?

Consistency with every other arch..no other reason.

> 
> > - * impractical.  So, now we fall back to using memcpy.
> > + * impractical.  So, now we fall back to using memmov.
> 
> That's memmove, not memmov.  Any why memmove, not memcpy?  Is __tmp likely to
> overlap with *ptr?
> 
> Also, for FRV, I think calling memmove/memcpy for MMU kernels may be the wrong
> thing to do...  I'm sort of leaning towards doing the same thing as NOMMU
> kernels and just using your inline ones.

OK, just let me know what you decide.  I'm stil open to bringing back
the frv asm versions if the do end up being faster.

> 
> The advantage of the inline ones is that they are quicker and probably involve
> fewer instructions executed; whereas using memcpy/memmove may end up with
> smaller, but slower code.  Hmmm...  Maybe key on CONFIG_CC_OPTIMIZE_FOR_SIZE?
> 

I suppose an out-of-line version could be easily added to accomplish
this.  It would be identical to the byteshifting implementation-wise.

Let me know if you'd like me to spin such a patch.

Harvey

