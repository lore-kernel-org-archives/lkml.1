Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbXEURth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbXEURth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbXEURtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:49:31 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:5271 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872AbXEURta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iMA2uEdXDMlpqhh2urUKCfAYI6Fb4KNeOWJDwPzkhF8+GVUBvoNoLtFmwW9ANBbLD38ZjKSAJYdQ7c0cQG9OvHR/lN+PxNwm3FmWkm34Rk+Qllaf7Z0pb/+cXTTGpwrD71Uyv5P0eNHCyDXm7X3svkLkSG8pss90etV8MmMMNGY=
Message-ID: <8bd0f97a0705211049i25867b27kf0017602ad4a0537@mail.gmail.com>
Date: Mon, 21 May 2007 12:49:29 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 20/32] Blackfin arch: dma_memcpy borken for > 64K
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Aubrey Li" <aubrey.li@analog.com>
In-Reply-To: <84144f020705210426w1704e133k2559f8ceffe9268c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179742180228-git-send-email-bryan.wu@analog.com>
	 <11797421863363-git-send-email-bryan.wu@analog.com>
	 <84144f020705210426w1704e133k2559f8ceffe9268c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On 5/21/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > -void *dma_memcpy(void *dest, const void *src, size_t size)
> > +void *_dma_memcpy(void *dest, const void *src, size_t size)
>
> Minor nitpick: the established naming convention is two underscores, not one.

that should be marked as static now actually since the function isnt
for use outside of this file

> > +void *dma_memcpy(void *dest, const void *src, size_t size)
> > +{
> > +       size_t bulk;
> > +       size_t rest;
> > +       void * addr;
> > +
> > +       bulk = (size >> 16) << 16;
>
> I assume this is significantly faster on your architecture than:
>
>    bulk = size & ~0xFFFFUL;
>
> which is more readable?

actually they should get optimized to the same thing
-mike
