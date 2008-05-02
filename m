Return-Path: <linux-kernel-owner+w=401wt.eu-S935813AbYEBSRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935813AbYEBSRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765374AbYEBSRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:17:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:60272 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763059AbYEBSRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c7kM4cgczLd/tcPLMf3AIuVHGHTJKoJsLfmjZcgVwadfSHh75lttUcVTM2+kGS/0h8KmPi+KoNTvomE1GGQcmZXqpGUJxOVbVUrvv+XrrJpuQb0X9NoB4rtRqDz7z7LwRcBMa1iaWb5zHHmndXZuQvNhuyQsZ47pigDxIm0JehE=
Subject: Re: [PATCH 7/8] fs: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <481AFDC2.7030807@s5r6.in-berlin.de>
References: <1209700378.22362.23.camel@brick>
	 <481AFDC2.7030807@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Fri, 02 May 2008 11:17:28 -0700
Message-Id: <1209752248.26173.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 13:40 +0200, Stefan Richter wrote:
> Harvey Harrison wrote:
> >  fs/partitions/ldm.h |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/partitions/ldm.h b/fs/partitions/ldm.h
> ...
> >  /* Most numbers we deal with are big-endian and won't be aligned. */
> > -#define BE16(x)			((u16)be16_to_cpu(get_unaligned((__be16*)(x))))
> > -#define BE32(x)			((u32)be32_to_cpu(get_unaligned((__be32*)(x))))
> > -#define BE64(x)			((u64)be64_to_cpu(get_unaligned((__be64*)(x))))
> > +#define BE16(x)		get_unaligned_be16((x))
> > +#define BE32(x)		get_unaligned_be32((x))
> > +#define BE64(x)		get_unaligned_be64((x))
> 
> Why the double parentheses?

No reason.

> 
> More importantly, I would say ldm.c should rather use
> get_unaligned_be*() directly.  No need to hide what these macros are
> about by using a local alias.

Done, will send out a revised set.

> 
> After that, ldm.c should be inspected for whether really all of the
> accesses are unaligned.  If there are any which are guaranteed to be
> aligned, they should of course be turned into be*_to_cpu().  But
> separately from this conversion to get_unaligned_be*().

It looks like they are all needed from a quick inspection, the comments
seem to suggest that lots of the accesses will be unaligned.

Cheers,

Harvey

