Return-Path: <linux-kernel-owner+w=401wt.eu-S1946837AbXD3Vat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946837AbXD3Vat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946832AbXD3Vat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:30:49 -0400
Received: from gw.goop.org ([64.81.55.164]:57683 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423674AbXD3Vaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:30:30 -0400
Message-ID: <46366007.7070801@goop.org>
Date: Mon, 30 Apr 2007 14:30:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Christoph Hellwig <hch@infradead.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules
 too
References: <200704301227.598020000@suse.de>	<20070430102814.7E56E151D2@wotan.suse.de>	<20070430105009.GB14944@infradead.org> <20070430155548.381d1bad@the-village.bc.nu>
In-Reply-To: <20070430155548.381d1bad@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 30 Apr 2007 11:50:09 +0100
> Christoph Hellwig <hch@infradead.org> wrote:
>
>   
>> On Mon, Apr 30, 2007 at 12:28:14PM +0200, Andi Kleen wrote:
>>     
>>> Otherwise non GPL modules cannot even do basic operations
>>> like disabling interrupts anymore, which would be excessive.
>>>
>>> Longer term should split the single structure up into
>>> internal and external symbols and not export the internal
>>> ones at all.
>>>
>>> Signed-off-by: Andi Kleen <ak@suse.de>
>>>       
>> Ingo was dead-set against this and I kinda agree. 
>>     
>
> Ditto - do the work first then merge it.
>   

The majority of paravirt_ops entrypoints are things which are currently
exported as inline functions in headers anyway.  There isn't a lot which
would become available to modules under a CONFIG_PARAVIRT kernel which
isn't already available to a non-CONFIG_PARAVIRT kernel.

We can hide the few remaining entries, I suppose.  But any module which
used them would only work with a PARAVIRT kernel anyway, so its hardly
going to be the best course for a module author - assuming they're at
all useful anyway (ooh, look, we can activate an mm!).

If we want to address this consistently, then we could scatter a pile of
#ifndef MODULEs around the headers to make sure the inlines are not
visible to modules in either case.  And we could correspondingly nobble
paravirt_ops by masking unexported entries with #ifndef MODULE.

So it isn't worth worrying about the paravirt_ops export unless you also
deal with the non-PARAVIRT case.

    J
