Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbYDHEO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbYDHEO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 00:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYDHEOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 00:14:18 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:37235 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbYDHEOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 00:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qPgbmmh5pbWRnR5Vo6NjLwE1qhM94bQu355EAXKSQYv1szF5pvYnEqb3hCvazf9hMSAldftzLuvIVAOXlMAcqCVLFYlm/Bz5mrSjxjKlJRftaau4itOHfgZBgJiDvqkBciAowXwQ/pbNSov2h55BQa/acU9ABYinjixtSANO9Uk=
Message-ID: <aa79d98a0804072114q300e336eoec814ad6053c934d@mail.gmail.com>
Date: Tue, 8 Apr 2008 08:14:13 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: bootmem allocator
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440804071445l7bef949fg5c500f0c09ae40e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu>
	 <87iqytqwl7.fsf@basil.nowhere.org>
	 <86802c440804071445l7bef949fg5c500f0c09ae40e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 1:45 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Mon, Apr 7, 2008 at 12:44 PM, Andi Kleen <andi@firstfloor.org> wrote:
>  >
>  > Ingo Molnar <mingo@elte.hu> writes:
>  >
>  >  > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>  >  >
>  >  >> Hi Ingo, Peter,
>  >  >>
>  >  >> small question. It was a patch recently posted which removes memset(x,
>  >  >> 0, x) after __alloc_bootmem call. There are a few another code
>  >  >> snippets who still call memset(x, 0, x). And who is responsible for
>  >  >> memory clearing? bootmem allocator or caller?
>  >  >
>  >  > hm, bootmem allocator is supposed to clear memory. We have a couple of
>  >  > places that rely on that.
>  >
>  >  I was actually considering to change that for the GB pages hugetlbfs
>  >  patchkit, because memset for 1G is a little slow and not needed (will be cleared later
>  >  anyways) and it might be a problem for very large systems with a lot of such
>  >  pages at boot.
>
>  add another zalloc_bootmem?
>
>  YH
>

I think it would be a good idea ;) Btw maybe would be better to call
memset on the code witch relies on "clear" memory explicitly? So we will
clear memory allocated *only* if we really need this.

Cyrill
