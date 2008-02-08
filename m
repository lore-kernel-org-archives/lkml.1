Return-Path: <linux-kernel-owner+w=401wt.eu-S1760707AbYBHHtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbYBHHtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYBHHtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:49:04 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:20110 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbYBHHtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KPE8Qse+5x6sxCqS61p6ZGIMO9IWImZaoYrI9glGPTE/4MFrpZXBtsIAY4/8OzWOHA6T/9/irPT0QsnFIfjR/N6GfwV5YAD9fIoO8VI2zjgW3EPXJrnyCw57NCroi8Q4kXZpj4cqsvgpSdI2AkR8YTkxqVi7UjMd48MkSrx4UzY=
Message-ID: <84144f020802072348p2f9bda73m52fcc07e272dd68c@mail.gmail.com>
Date: Fri, 8 Feb 2008 09:48:58 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>
In-Reply-To: <Pine.LNX.4.64.0802072307040.22292@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <Pine.LNX.4.64.0802072307040.22292@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 14d4db9369e0dc1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, 7 Feb 2008, Vegard Nossum wrote:
> > - DMA can be a problem since there's generally no way for kmemcheck to
> >   determine when/if a chunk of memory is used for DMA. Ideally, DMA should be
> >   allocated with untracked caches, but this requires annotation of the
> >   drivers in question.

On Feb 8, 2008 9:10 AM, Christoph Lameter <clameter@sgi.com> wrote:
> There is a fundamental misunderstanding here: GFP_DMA allocations have
> nothing to do with DMA. Rather GFP_DMA means allocate memory in a special
> range of physical memory that is required by legacy devices that cannot
> use the high address bits for one or the other reason. Any regular
> memory can be used for DMA.

No there isn't and we've been over this with Vegard many times :-).
Christoph, can you actually see this in the patch? There shouldn't be
any __GFP_DMA confusion there. What we have is per-object
__GFP_NOTRACK which can be used to suppress false positives for
DMA-filled objects and SLAB_NOTRACK for whole _caches_ that contains
objects which we must not take page faults at all.
