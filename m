Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752116AbYLRNri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbYLRNri (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 08:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYLRNrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 08:47:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYLRNrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 08:47:24 -0500
Message-ID: <494A546C.2020003@vlnb.net>
Date: Thu, 18 Dec 2008 16:47:24 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Fabio Checconi <fabio@gandalf.sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: Dynamic switching of io_context
References: <4942B90F.6050807@vlnb.net> <20081216082235.GD3284@gandalf.sssup.it> <49494A50.3090201@vlnb.net> <20081218134006.GP32491@kernel.dk>
In-Reply-To: <20081218134006.GP32491@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/gRyyfI2q2kfke+jbVYawsn8tyP6aMGsBPIO+
 dhUTYIXVgMYbIVz41MobC2K5farE86AWhC403buofmTyJPLRMZ
 IcjyaOm36gx9PTAq3Xvcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe, on 12/18/2008 04:40 PM wrote:
> On Wed, Dec 17 2008, Vladislav Bolkhovitin wrote:
>>> I haven't seen the rest of the code, so I may be wrong, but I suppose
>>> that a better approach would be to use CLONE_IO to share io contexts,
>>> if possible.
>> Unfortunately, it would be very non-optimal. As it is known, to achieve 
>> the best performance with async. IO, it should be submitted by a limited 
>> number of threads <= CPU count. So, the only way to submit IO from each 
>> of, e.g. 100, clients in a dedicated per-client IO context is to 
>> dynamically switch io_context of the current threads to io_context of 
>> the client before IO submission.
> 
> There's also likely to be another use of exactly the same type of thing
> - the acall patches from Zach. At least my vision of the punt-to-thread
> approach would be very similar: grab an available thread and attach it
> to a given IO context.
> 
> So while I did mention exactly what Fabio outlines in my initial mail on
> this, a generic way to attach/detach IO contexts from processes/threads
> would be useful outside of this project. nfsd comes to mind as well.

I fully agree. Looking forward to use that facility in 2.6.29! (I guess, 
from your reference on Zach's patches, that the work is being done. If 
I'm wrong and you need my participation in implementing it, just let me 
know.)

Thanks,
Vlad


