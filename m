Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZF2RkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZF2RkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZF2RkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:40:01 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51805 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbZF2RkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:40:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=j1lDspx9wMfeLLeY3V/OhYuTqTO3pfj4NbxLTujaHJEEhwfcqzb8+wBA0rnh3YGa+J
         SSyywxiwtWT4ya++hVpiQFz3bXhjw6oKRaV2UXOqsc+SZDxmwOhyfAd/wWbI7cTSayEk
         rUnv8+BOROHhTrwkxl7E1q9aBfFK0LK8qp3rM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Etienne Basset <etienne.basset@numericable.fr>
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
Date: Mon, 29 Jun 2009 19:45:36 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       jeff.chua.linux@gmail.com
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <20090629.033730.193709457.davem@davemloft.net> <4A48E307.2010208@numericable.fr>
In-Reply-To: <4A48E307.2010208@numericable.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906291945.38821.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009 17:51:35 Etienne Basset wrote:
> David Miller wrote:
> > From: Etienne Basset <etienne.basset@numericable.fr>
> > Date: Mon, 29 Jun 2009 12:29:09 +0200
> > 
> >> yes, patch is not yet upstream;
> > 
> > I'll take care of pushing this around today.
> > 
> Hi,
> 
> thank you ; 
> i ran a new bisection to identify the commit that cause pain after -rc1
> 
> etienne@etienne-desktop:~/linux-2.6$ git bisect good        
> a1317f714af7aed60ddc182d0122477cbe36ee9b is first bad commit

Thanks for finding it.

Dave, please just revert this patch (it wasn't meant for Linus' tree anyway).

> commit a1317f714af7aed60ddc182d0122477cbe36ee9b             
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>      
> Date:   Tue Jun 23 23:52:17 2009 -0700                      
> 
>     ide: improve handling of Power Management requests
>                                                       
>     Make hwif->rq point to PM request during PM sequence and do not allow
>     any other types of requests to slip in (the old comment was never correct
>     as there should be no such requests generated during PM sequence).       
>                                                                              
>     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>            
>     Signed-off-by: David S. Miller <davem@davemloft.net>   
> 
> To have STR/resume work with current git, I have to :
> 1) apply Bart's patch
> 2) revert this commit : a1317f714af7aed60ddc182d0122477cbe36ee9b
> 
> thanks
> Etienne           
> 
> 
