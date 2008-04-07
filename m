Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYDGVqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYDGVqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYDGVqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:46:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:11465 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYDGVqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dXUQRpuvgO6L9sle4qXHrsPPSG0hw6ReekbQGjd3l4ugeYBRvZwiDHM5aA74Pnn+u3AKJPUuEF3358fP5ruvfhocoUKhnPexfLc150L0tc4B5gFN5lSGn6aBpo7bYApTanN7hw35LnJxBOzEVcpXP0GpY9on4Mb7nQTHrhAFT3Y=
Message-ID: <86802c440804071445l7bef949fg5c500f0c09ae40e@mail.gmail.com>
Date: Mon, 7 Apr 2008 14:45:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: bootmem allocator
Cc: "Ingo Molnar" <mingo@elte.hu>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <87iqytqwl7.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu>
	 <87iqytqwl7.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2008 at 12:44 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Ingo Molnar <mingo@elte.hu> writes:
>
>  > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>  >
>  >> Hi Ingo, Peter,
>  >>
>  >> small question. It was a patch recently posted which removes memset(x,
>  >> 0, x) after __alloc_bootmem call. There are a few another code
>  >> snippets who still call memset(x, 0, x). And who is responsible for
>  >> memory clearing? bootmem allocator or caller?
>  >
>  > hm, bootmem allocator is supposed to clear memory. We have a couple of
>  > places that rely on that.
>
>  I was actually considering to change that for the GB pages hugetlbfs
>  patchkit, because memset for 1G is a little slow and not needed (will be cleared later
>  anyways) and it might be a problem for very large systems with a lot of such
>  pages at boot.

add another zalloc_bootmem?

YH
