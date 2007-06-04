Return-Path: <linux-kernel-owner+w=401wt.eu-S1761446AbXFDTNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbXFDTNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760507AbXFDTNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:13:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:65116 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760547AbXFDTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CyiqOJfPD27wYVfqJ8oXWnOUs/QfrQGGm0PPKiRvzL1QAJvk+lSMdUSYuMvQ5qtIybleuROpNXtqN/0qf8miWdkXPHDLGmQ/0f7IiJ2EVwgjk6+rWW3jBmSruP5jKU6Iqt1sYPaiwO1bOelOdu8zNTrNuYBnpNkIn//x3Z5gtas=
Message-ID: <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com>
Date: Mon, 4 Jun 2007 22:13:30 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
	 <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: a4a23fbbc1a92749
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On 6/4/07, Christoph Lameter <clameter@sgi.com> wrote:
>         /*
> -        * We should return 0 if size == 0 (which would result in the
> -        * kmalloc caller to get NULL) but we use the smallest object
> -        * here for legacy reasons. Just issue a warning so that
> -        * we can discover locations where we do 0 sized allocations.
> +        * The behavior for zero sized allocs changes. We no longer
> +        * allocate memory but return ZERO_SIZE_PTR.
> +        * WARN so that people can review and fix their code.
>          */
>         WARN_ON_ONCE(size == 0);

I thought the whole point of this patch was to get rid of the WARN_ON
as you will get a nice oops if you dereference the pointer?
