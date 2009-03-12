Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZCLA2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZCLA2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZCLA2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:28:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:38797 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbZCLA2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:28:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RwZIW2lmW/7eHR+TvJZuGGjFHuz+xHlEFjFnzQqTg2uGK6oKQfaUgHSoDq+H7YZhHm
         ie+WgjkzJXq3gympuuQPARVNz3HJJSW2jrNB36zKQNos3pGMf/wtspV2PsP4E1V2DVrH
         FvIwAhK72d3CUGBF0Z9D5tvLS0982RNMGZZig=
MIME-Version: 1.0
In-Reply-To: <20090311165252.GB30777@elte.hu>
References: <20090311143317.GA22244@localhost.localdomain>
	 <alpine.LFD.2.00.0903111606350.29264@localhost.localdomain>
	 <961aa3350903110825y1af77709q49d6328703081afb@mail.gmail.com>
	 <20090311165252.GB30777@elte.hu>
Date: Thu, 12 Mar 2009 09:28:09 +0900
Message-ID: <961aa3350903111728m6203106tf74a767f1a82e663@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: unify kmap_atomic_pfn() and iomap_atomic_prot_pfn()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/12 Ingo Molnar <mingo@elte.hu>:
>
> * Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> 2009/3/12 Thomas Gleixner <tglx@linutronix.de>:
>> > On Wed, 11 Mar 2009, Akinobu Mita wrote:
>> >> kmap_atomic_pfn() and iomap_atomic_prot_pfn() are almost same except
>> >> pgprot. This patch removes the code duplication for these two functions.
>> >
>> > How exaclty does this compile with CONFIG_HIGHMEM=n ?
>> >
>>
>> Oh, I didn't try without CONFIG_HIGHMEM.
>
> i had it applied in testing locally and didnt see problems so
> far. Let me know if you can see any problems.

It actually didn't compile with CONFIG_HIGHMEM=n as Thomas pointed out.

arch/x86/mm/iomap_32.c:49: undefined reference to `kmap_atomic_prot_pfn'

So please revert 1/2 and 2/2. However, I still think 2/2 is usefull and
I'll submit it in other form.
