Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbXJWTzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbXJWTzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 15:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXJWTy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 15:54:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:11549 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbXJWTy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 15:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=TPF2ORxRHhD5UGzQ8qjXzW534iCWRfqP6v2y5EQWuuV24/v26pOxAhi1ZRQaNEKnjXlD2dcWyJalsRziP2sZQvXXrYUMEhFlQFux2zK8x1usba+JRusxMS0mVQuq7Y53cuBiwkXA6uYoJJRCMI1PoTd16f6HaN6iZALS6krGT9Y=
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: drivers/net/wireless/rt2x00/: struct data_desc strangeness
Date: Tue, 23 Oct 2007 22:13:46 +0200
User-Agent: KMail/1.9.7
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071014175032.GI4211@stusta.de> <200710142106.20409.IvDoorn@gmail.com> <20071023194344.GX30533@stusta.de>
In-Reply-To: <20071023194344.GX30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710232213.47105.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > I haven't checked whether it might work in all cases, but passing 
> > > non-zero values as second parameter to rt2x00_desc_{read,write}()
> > > (as is done in many cases) is even in the best case bad coding style.
> > 
> > Access to the array is correct, even with non-zero values the code that is
> > reading/writing to the array knows the exact size of the descriptor. Within
> > rt2x00 are however 5 drivers who have different descriptor sizes. That means
> > I can't create a structure which has the correct array length.
> > 
> > The structure itself is just a simple map over preallocated memory
> > (skb->data in case of USB or dma in case of PCI).
> > 
> > So possible solutions would be:
> >  - remove struct data_desc and make it a void* or __le32*
> >    This is at the cost of code readibility since the above pointers
> >    have less meaning then a pointer to a structure which can be nicely
> >    documented.
> >...
> 
> The worst is a wrong meaning.
> __le32 word[1] is an array with _one_ element.
> 
> And an __le32* can be used as an array.

Ok. I'll fix this in 1 or 2 days.

Ivo
