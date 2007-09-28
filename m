Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbXI1HDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbXI1HDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 03:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756923AbXI1HDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 03:03:05 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39331 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbXI1HDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 03:03:04 -0400
Message-ID: <46FCA87F.3000605@bull.net>
Date: Fri, 28 Sep 2007 09:08:47 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: akpm@linux-foundation.org, adobriyan@sw.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm1 1/2] fixing idr_find() locking
References: <20070927143354.663489000@bull.net> <20070927143458.674281000@bull.net> <20070928063144.GB1767@ff.dom.local>
In-Reply-To: <20070928063144.GB1767@ff.dom.local>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 09:09:02,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 09:09:08,
	Serialize complete at 28/09/2007 09:09:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> On Thu, Sep 27, 2007 at 04:33:55PM +0200, Nadia.Derbey@bull.net wrote:
> 
>>[PATCH 01/02]
>>
>>
>>This is a patch that fixes the way idr_find() used to be called in ipc_lock():
>>in all the paths that don't imply an update of the ipcs idr, it was called
>>without the idr tree being locked.
>>
>>The changes are:
>>  . in ipc_ids, the mutex has been changed into a reader/writer semaphore.
>>  . ipc_lock() now takes the mutex as a reader during the idr_find().
>>  . a new routine ipc_lock_down() has been defined: it doesn't take the
>>    mutex, assuming that it is being held by the caller. This is the routine
>>    that is now called in all the update paths.
>>
>>
>>Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> 
> 
> Acked-by: Jarek Poplawski <jarkao2@o2.pl>
> 
> PS: there is one big mistake around To/Cc ordering, so I doubt Andrew
> will ever sign this...
> 
> 

Jarek,

I thought that since you were the one who pointed out the issue I had to 
put you as the receiver.
Next time I'll also add Andrew in the To list.
Sorry for that.

Regards,
Nadia

