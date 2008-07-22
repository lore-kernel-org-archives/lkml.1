Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYGVS1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYGVS1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYGVS1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:27:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:35628 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYGVS1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:27:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Zfjpt+X55zWBtAVo9qYCKBrVC8/7K+U/cUWzew/T7QB1Le9dVSH5nUu32nBt+9kRTa
         kQs1Oqp5GwC1b6aew1HNUGp/3iUoB9vuRJVx0tGpYYkoRHkF+zxRtBEl0tPCjBql0roW
         FobAwHOj7MRiYWc5zmj8df/nUk9mCIElz+VXM=
Message-ID: <19f34abd0807221127q1c26fed7w5b276cadb7319fec@mail.gmail.com>
Date: Tue, 22 Jul 2008 20:27:11 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: more header fixes
Cc: linux-kernel@vger.kernel.org, "the arch/x86 maintainers" <x86@kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080722113823.GA9351@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716142225.GA19054@elte.hu>
	 <20080722123231.GA13172@localhost.localdomain>
	 <20080722103632.GA27029@elte.hu>
	 <19f34abd0807220413sabb9f65h6ac20f98efb680bf@mail.gmail.com>
	 <20080722113823.GA9351@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 1:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> Though I still believe it should be squashed for bisectability.
>
> hm, i pulled it but 1ab9e368 cannot be squashed into aa27f9586 cleanly.

Yes, you are right. I forgot to check.

> I'd suggest the following approach, which we used for the scripted
> unification of arch/x86. Do a couple of preparatory patches that just
> bring all the header guards into proper shape. _Then_ run the script
> against that "prepared" tree. The end result should be correct to the
> best of our current knowledge. (i'll figure out any remaining build
> breakages quickly - i can build 120+ random kernels per hour)
>
> We can rebase x86/header-guards to such a bisectable approach no problem
> if you can do it like that, it's not yet merged anywhere. Just send me a
> pull URI that i'll pull into a x86/header-guards that is reset back to
> linus/master.
>
> Can you see any complications with that approach?

There's not really that much to prepare. But it really helps to work
against the right tree to begin with :-)

So here's another one, this time prepared against linus/master, and
fully bisectable by delaying the fixing of the headers which have
external users of their guard-names. Check out the (new) 'for-tip'
branch of

    git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git

There are still headers left which have no guard at all; that's okay.
If they should be changed, it can be done later, it shouldn't make a
difference for now.

Thanks :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
