Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZF3BYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZF3BYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZF3BYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:24:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:55309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZF3BYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:24:38 -0400
Message-ID: <4A496946.8080409@kernel.org>
Date: Mon, 29 Jun 2009 18:24:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>	<19013.29264.623540.275538@pilspetsen.it.uu.se>	<4A45A5C1.5080701@zytor.com>	<19013.59956.144640.331854@pilspetsen.it.uu.se>	<20090629022911.GC20297@lackof.org>	<4A484A8A.9020704@zytor.com>	<19016.41349.636663.515540@pilspetsen.it.uu.se>	<20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com> <4A4966EF.6010809@kernel.org> <4A4967CF.2080007@zytor.com>
In-Reply-To: <4A4967CF.2080007@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>>>>  
>>> That doesn't quite look right; for one thing it doesn't handle the
>>> (admittedly somewhat unlikely) case of end pointing to the end of the
>>> address space.
>>>
>>> Something like:
>>>
>>> 	if (start > (resource_size_t)end-1)
>>> 		continue;
>>>
> 
>> +		if (start > (resource_size_t)end)
>>  			continue;
> 
> Erk... thinko on my part.  Should have been (resource_size_t)-1.
> 

how about start is already 32M ?
you will insert blank one...

64bit, we could expand range that is above 4g to be aligned.

YH
