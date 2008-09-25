Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYIYWf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYIYWf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 18:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYIYWfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 18:35:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60876 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbYIYWfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 18:35:47 -0400
Message-ID: <48DC11F5.20900@redhat.com>
Date: Thu, 25 Sep 2008 18:34:29 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Kevin Hao <kexin.hao@windriver.com>, Jeff Garzik <jgarzik@redhat.com>,
       Jay Cliburn <jacliburn@bellsouth.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: remove LLTX in atl2 driver
References: <1222302922-13200-1-git-send-email-kexin.hao@windriver.com> <48DBF4DD.8060908@redhat.com> <48DBFAB5.2010709@garzik.org>
In-Reply-To: <48DBFAB5.2010709@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Chris Snook wrote:
>> Kevin Hao wrote:
>>> When NETIF_F_LLTX is set, the atlx driver will use a private lock.
>>> But in recent kernels this implementation seems redundant and
>>> can cause problems where AF_PACKET sees things twice. Since
>>> NETIF_F_LLTX is marked as deprecated and shouldn't be used in
>>> new driver, this patch removes NETIF_F_LLTX and adds a mmiowb
>>> before sending packet.
>>>
>>> Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
>>
>> Can you explain a bit more concretely the problem this solves, and 
>> your testing?  Ultimately we'll want to merge this code with the atl1 
>> code, so we need to be confident that we can and should make the same 
>> change there.
>>
>> -- Chris
>>
>>> ---
>>>  drivers/net/atlx/atl2.c |   24 +-----------------------
>>>  drivers/net/atlx/atl2.h |    1 -
>>>  2 files changed, 1 insertions(+), 24 deletions(-)
> 
> Not directly addressing your question, but LLTX is indeed deprecated and 
> in general we want to move away from it.
> 
>     Jeff

I'm all in favor of removing legacy cruft.  I want to know a little more about 
it so we can remove it from the atl1 code as well.  Ultimately most of this will 
be shared code.

-- Chris
