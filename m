Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbZF2Pvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbZF2Pvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZF2Pvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:51:36 -0400
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:54863 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZF2Pvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:51:35 -0400
Message-ID: <4A48E307.2010208@numericable.fr>
Date: Mon, 29 Jun 2009 17:51:35 +0200
From: Etienne Basset <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       bzolnier@gmail.com, jeff.chua.linux@gmail.com
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>	<5Hhc7UkUKEO.A.RvE.BjASKB@chimera>	<4A489775.6020102@numericable.fr> <20090629.033730.193709457.davem@davemloft.net>
In-Reply-To: <20090629.033730.193709457.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Etienne Basset <etienne.basset@numericable.fr>
> Date: Mon, 29 Jun 2009 12:29:09 +0200
> 
>> yes, patch is not yet upstream;
> 
> I'll take care of pushing this around today.
> 
Hi,

thank you ; 
i ran a new bisection to identify the commit that cause pain after -rc1

etienne@etienne-desktop:~/linux-2.6$ git bisect good        
a1317f714af7aed60ddc182d0122477cbe36ee9b is first bad commit
commit a1317f714af7aed60ddc182d0122477cbe36ee9b             
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>      
Date:   Tue Jun 23 23:52:17 2009 -0700                      

    ide: improve handling of Power Management requests
                                                      
    Make hwif->rq point to PM request during PM sequence and do not allow
    any other types of requests to slip in (the old comment was never correct
    as there should be no such requests generated during PM sequence).       
                                                                             
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>            
    Signed-off-by: David S. Miller <davem@davemloft.net>   

To have STR/resume work with current git, I have to :
1) apply Bart's patch
2) revert this commit : a1317f714af7aed60ddc182d0122477cbe36ee9b

thanks
Etienne           

