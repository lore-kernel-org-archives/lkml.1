Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZEKLXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZEKLXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 07:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbZEKLXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 07:23:21 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:34888 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770AbZEKLXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 07:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GNO+U/8RarMNRhdFJXJ0dZDoD29DUUD2f1zSnTTmxNBHtMhXqLVf50lFNwY/huu8Cb
         HSsNLAkTGRA/LPS7b+QfiN1anIz263dL3B1BdrkfF701usoZuQk1XN6vkDAblPxvBMGl
         D9Q9pNIFU1192RX9XjGR0NJEEC1TX51RSejQs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0905110146140.24726@chino.kir.corp.google.com>
References: <20090511085750.B9AC.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0905101719040.31823@chino.kir.corp.google.com>
	 <20090511104310.B9C1.A69D9226@jp.fujitsu.com>
	 <20090511164008.894320db.minchan.kim@barrios-desktop>
	 <alpine.DEB.2.00.0905110146140.24726@chino.kir.corp.google.com>
Date: Mon, 11 May 2009 20:23:20 +0900
Message-ID: <28c262360905110423n4878edc5k69a89d67ef1ab501@mail.gmail.com>
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 5:49 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 11 May 2009, Minchan Kim wrote:
>
>> I agree KOSAKI's opinion.
>> We already have a different flags.
>>
>>  * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
>>  * _might_ fail.  This depends upon the particular VM implementation.
>>  *
>>  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
>>  * cannot handle allocation failures.
>>
>> When we use __GFP_NOFAIL, we always have to use it carefully.
>> If you change the meaning of __GFP_NOFAIL, the intension of them who have been used it carefully  may be lost. It's my concern.
>>
>
> You pointed out yourself that __GFP_NOFAIL allocations can fail by way of
> having alloc_pages() return NULL even without attempting to free memory by
> the oom killer for order > PAGE_ALLOC_COSTLY_ORDER.  The definition you
> posted above is unambiguous to me, it means we must retry infinitely.  And
> that's very stupid if we are going to neglect to free memory by killing a
> task and relying solely on reclaim which may not make any progress.
>

Sorry for confusing. Ignore me, please.
I misunderstood your description as I said previous post. :)

-- 
Kinds regards,
Minchan Kim
