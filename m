Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYCUVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYCUVnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYCUVnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:43:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:15370 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbYCUVnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RPSDqpbK521IxaiQMvdFucrJwCLVtehikUSRNcc4cJKEuUcA2ttdpiwq9toot6wM4u8z2NwVFT75zMb6mwVMyaoUKmNZHmgpwg7WI6ujPy3r09TtftLzB0oHpuIsTknmuqlWKLwBkn2TU0pVO5IY3zBZXL5xHh/+F8iz6lLS7bg=
Message-ID: <86802c440803211443o7bbc539fx762e06f51c6f0fdb@mail.gmail.com>
Date: Fri, 21 Mar 2008 14:43:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] x86_64: early memtest to find bad ram
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.00.0803212221390.10642@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803202358.33722.yhlu.kernel@gmail.com>
	 <20080321120313.GD25225@elte.hu>
	 <alpine.LNX.1.00.0803212221390.10642@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 2:22 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
>  On Mar 21 2008 13:03, Ingo Molnar wrote:
>  > * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>  >
>  >> do simple memtest after init_memory_mapping
>  >> use find_e820_area_size to find all ram range that is not reserved.
>  >> and do some simple bits test to find some bad ram.
>  >> if find some bad ram, use reserve_early to exclude that range.
>  >
>  > very nice patch! I always thought that this was the proper way to do
>  > memtest - and we could in fact also do something like this after SMP
>  > bringup, and hit the memory bus via multiple CPUs. [that will need a
>  > different enumeration though than e820 maps]
>
>  Perhaps this can even be used to provide on-the-fly badram
>  patch semantics?

yes. but bad ranges can not be too many. otherwise early_res array
will overflow. then need to use memmap=nn$ss to exclude range already
found.

YH
