Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbXJKG0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbXJKG0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbXJKG0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:26:36 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:21166 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbXJKG0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CMgY1wRqDvmVBBGLxyfpMdSh1lk/cxiX84eNFuqFwqE69yZ/BS/U7DrNrSbKK1zojO57WN2GR4jjE8RkNTxzvGKjy3lai2kS/ofhw0IDzw6E5OSHu4KWYUBd7iwpDldHr8MFPnqhv7uhQE74LzSGiO/Rk7mmpsrQaHnF+CSj7J4=
Message-ID: <470DC213.5080307@gmail.com>
Date: Thu, 11 Oct 2007 15:26:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>	 <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>	 <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>	 <20071003163804.GR19691@waste.org>	 <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>	 <20071004170536.GY19691@waste.org>	 <64bb37e0710042306s6c629163gde7bc5c93973153e@mail.gmail.com>	 <64bb37e0710070144m6bc2c844oc96ef715b53b9819@mail.gmail.com>	 <64bb37e0710070739s67805d72x6d675cb2af2e8b24@mail.gmail.com>	 <470D97BD.4020300@gmail.com> <64bb37e0710102254n60e22338t4baf75a47b93ac14@mail.gmail.com>
In-Reply-To: <64bb37e0710102254n60e22338t4baf75a47b93ac14@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
>>> That missing +1 would explain, why the SGE_TRM never gets set.
>> Thanks a lot for tracking this down.  Does changing the above code fix
>> your problem?
> 
> I did not try it.
> I'm not an libata expert and while this change looks suspicios, I
> can't be 100% sure if that change was intended.
> And I did not want to experiment this deep in the code and risk
> corrupting the hole drive.

I don't think you would risk too much by changing that bit of code.
Please try it.

>>> But I'm still not understanding, how the kernel could only fail
>>> sometimes at bootup, but after that working without any visible
>>> errors? Is the sil-chip rather intelligent about detecting corrupted
>>> sglists and silently ignoring them?
>> I have no idea why it fails only sometimes.
> 
> And that is, why I'm so unsure.
> The error looks to serious to only cause random failures on one of two
> drives on bootup.
> I never had trouble with the remaining drive on the SiI-chip or both
> drives if one got killed during booting.
> 
> I'm guessing that leaving the computer powered down long enough fills
> the RAM with a special pattern that really hangs the drive, while
> normaly it would just reject the invalid data. (I have ECC-RAM, does
> this matter?)
> 
> Another guess might be that most of the time the Sil-chip correctly
> terminates after the transfer-length is reached, even if SGE_TRM is
> missing...

I have no idea either.  We'll probably need a PCI bus tracer to tell
exactly what's going on.

Thanks.

-- 
tejun
