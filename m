Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbXK1VSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbXK1VSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbXK1VPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:45 -0500
Received: from gw.goop.org ([64.81.55.164]:57076 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758629AbXK1VPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:43 -0500
Message-ID: <474DDA7B.9090802@goop.org>
Date: Wed, 28 Nov 2007 13:15:39 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tobias Powalowski <t.powa@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] x86/paravirt: revert exports to restore old behaviour
References: <474CA0DA.3010005@goop.org> <20071128204050.GA29463@stusta.de>
In-Reply-To: <20071128204050.GA29463@stusta.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Nov 27, 2007 at 02:57:30PM -0800, Jeremy Fitzhardinge wrote:
>   
>> ...
>> Christoph Hellwig objects to this patch on the grounds that modules
>> shouldn't be using these operations anyway.  I don't think this is a
>> particularly good reason to reject the patch, for several reasons:
>>
>> 1. These operations are still available to modules when not using
>>    CONFIG_PARAVIRT, since they are implicitly exported as inline
>>    functions via the kernel headers.  Exporting the same functionality as
>>    GPL-only symbols just adds a gratuitious difference between
>>    CONFIG_PARAVIRT and non-CONFIG_PARAVIRT configurations.  If we really
>>    think these operations are not for module use (or non-GPL module use),
>>    then we should solve the problem in a general way.
>>     
>
> Current practice in the kernel is that when something that should not be 
> done works by chance with some kernel versions and/or configurations 
> that's simply an unfortunate fact that should be fixed but doesn't 
> result in any guarantee that it works with all kernel versions and/or 
> configurations.
>   

Well, I suppose, but there's nothing particularly "internal" about the
functions that these modules want to get access to.  They are the proper
API functions for doing what the modules want to do.

And we have enough weird little config-dependent corners of the kernel
API that complicate testing; I don't think we need to knowingly
introduce more.

>> 2. It's a regression from previous kernels, which would work these
>>    modules even with CONFIG_PARAVIRT enabled.
>> ...
>>     
>
> It cannot be a regression since the kernel does not have a stable API 
> for modules.
>   

Anything that once worked but now does not is a regression.  Generally
when we intend a regression like this, we call it a deprecation of an
interface and have a procedure for that.  It was not my intention to
cause a regression with this change, and an unintended regression is a bug.

>> Therefore, I think this patch should go in for 2.6.24.  If people
>> really think that these operations should not be available to modules,
>> then we can address that separately.
>> ...
>>     
>
> Why should we start with one step back for getting two steps ahead?
>   

Why is it a step back?  What are the steps ahead?  There's been no
discussion on this point, so I don't think you can assume there's a
clear way forward.

I think Linus and Andrew have been pretty clear on the policy for these
kinds of things: regressions are always bad, even if fixing the
regression means some other bugfix needs to be put off.

    J
