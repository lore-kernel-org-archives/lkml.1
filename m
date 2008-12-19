Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbYLSRiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbYLSRiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYLSRhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:37:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56976 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYLSRht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:37:49 -0500
Message-ID: <494BDBFC.7060707@vlnb.net>
Date: Fri, 19 Dec 2008 20:38:04 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC]: Support for zero-copy TCP transmit of user space data
References: <494009D7.4020602@vlnb.net> <494012C4.7090304@vlnb.net>	<20081210214500.GA24212@ioremap.net> <4941590F.3070705@vlnb.net>	<1229022734.3266.67.camel@localhost.localdomain>	<4942BAB8.4050007@vlnb.net>	<1229110673.3262.94.camel@localhost.localdomain>	<49469ADB.6010709@vlnb.net> <20081215231801.GA27168@infradead.org>	<4947FA1C.2090509@vlnb.net> <494A97DD.7080503@vlnb.net> <87zlisz9pg.fsf@basil.nowhere.org>
In-Reply-To: <87zlisz9pg.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/9XF0QKfZ6yYhlkLQWKkZ9a7gfnAkpMjQlxug
 pLnN5lU4ukcRcKypQkKb5K+ZP7nhMPSDo+h2pvjghnH7XRZyye
 fX9r6MMHCaIqLLhsPPzJw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen, on 12/19/2008 02:27 PM wrote:
> Vladislav Bolkhovitin <vst@vlnb.net> writes:
>>  - Although usage of struct page to keep network related pointer might
>> look as a layering violation, it isn't. I wrote in
>> http://lkml.org/lkml/2008/12/15/190 why.
> 
> Sorry but extending struct page for this is really a bad idea because
> of the extreme memory overhead even when it's not used (which is a 
> problem on distribution kernels) Find some other way to store this
> information.  Even for patches with more general value it was not
> acceptable.

Sure, this is why I propose to disable that option by default in 
distribution kernels, so it would produce no harm. ISCSI-SCST can work 
in this configuration quite well too. People who need both iSCSI target 
*and* fast working user space device handlers would simply enable that 
option and rebuild the kernel. Rejecting this patch provides much worse 
alternative: those people would also have to *patch* the kernel at 
first, only then enable that option, then rebuild the kernel. (I'm 
repeating it to make sure you didn't miss this my point; it was in the 
part of my original message, which you cut out.)

Thanks,
Vlad
