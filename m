Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbZEUKnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbZEUKnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZEUKnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:43:24 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:26221 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZEUKnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Rim57YTR1OQJBRZhhFj3yYXbfkxhV6DxJtC7yCSHGvDfky+YcgMG6ezQMna1+KHn2f
         M/N1jbi62BV5zwH8wkFYEIraZJg+JrlmwDbzt897gOQovNxgN6kBBc7fHLUENZjCkoRB
         v6bphvDdZgC5bni+s50cIg2W4O6EyylkU+kRg=
MIME-Version: 1.0
In-Reply-To: <20090512150552.a98dca64.akpm@linux-foundation.org>
References: <1242117363-14949-1-git-send-email-leoli@freescale.com>
	 <1242117363-14949-2-git-send-email-leoli@freescale.com>
	 <1242117363-14949-3-git-send-email-leoli@freescale.com>
	 <20090512150552.a98dca64.akpm@linux-foundation.org>
Date: Thu, 21 May 2009 18:43:23 +0800
X-Google-Sender-Auth: b9793f51b3626bca
Message-ID: <2a27d3730905210343k1e44225eh5555de768abdbb03@mail.gmail.com>
Subject: Re: [PATCH 3/6] powerpc: add memory map support to Freescale RapidIO 
	block
From: Li Yang <leoli@freescale.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: galak@kernel.crashing.org, davem@davemloft.net,
       mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org, zw@zh-kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 6:05 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 12 May 2009 16:36:00 +0800
> Li Yang <leoli@freescale.com> wrote:
>
>> +     align = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
>> +
>> +     /* Align the size */
>> +     if ((lstart + size) > (_ALIGN_DOWN(lstart, align) + align)) {
>
> __ilog2() and _ALIGN_DOWN() are powerpc-specific functions.  It would
> be preferable to use more general helpers if possible.  ALIGN() and ilog2()
> might suit here.

Will change to use ilog2().

_ALIGN_DOWN() gets a lower aligned address while ALIGN() gets a higher
address.  It seems that we don't have a general helper to do the same.

- Leo
