Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbYH1Arp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbYH1Arp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbYH1Arg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:47:36 -0400
Received: from gw.goop.org ([64.81.55.164]:50877 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbYH1Arg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:47:36 -0400
Message-ID: <48B5F5A6.4060309@goop.org>
Date: Wed, 27 Aug 2008 17:47:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Hugh Dickens <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: Definition of x86 _PAGE_SPECIAL and sharing _PAGE_UNUSED1
References: <48B5A4B0.9050308@goop.org> <200808281032.30594.nickpiggin@yahoo.com.au>
In-Reply-To: <200808281032.30594.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Ah... pity it was hidden away there and not put into the include file.
>   

Yes.  I just prepped a patch to bring it out into the light.

> I don't feel strongly about it. But you should put your definition in
> pgtable.h (and possibly explain how it coexists with _SPECIAL).
>   

Yes, that was my plan, but without knowing how _SPECIAL is used, it's a
bit tricky.  Is there a comment somewhere which describes who sets it
and when?  From a quick look, it seems it's set on newly added user
pages which aren't COWed.  Can they be shared file-backed pages? 
Anonymous pages?  Device pages?

>> Am I right in supposing that _PAGE_SPECIAL can only be set on user pages?
>>     
>
> Yes.
>   

OK, that won't clash with CPA tests at all, since they're kernel only.

>> (Also, "SPECIAL" is awfully generic.  Was there really no more
>> descriptive name for this?)
>>     
>
> I thought it was about on par with its counterpart, which is "normal".
> Either way, I don't think a casual reader would get an adequate idea
> of how it works in one word. normal ~= refcounted, special ~= !refcounted
> I guess, but it is slightly more than that and besides, normal was there
> first, and I think Linus coined it... if you can convince him to change
> it then you have my blessing to change special into whatever you want.
>   

It's only used in a couple of places, so giving it a longer name
wouldn't cost much.  _PAGE_USER_UNCOUNTED?  But ugh, a lot of cross-arch
churnpatch to do it.

    J

