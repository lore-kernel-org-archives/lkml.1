Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231Ab0AGHsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0AGHsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:48:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012Ab0AGHsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:48:11 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:56198 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0AGHsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:48:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n0xFUYnrsi+ADLe2TTxya8m2E314OofRnZGVLPtZPQ2juI3gia1GC727ezFLKFdgwD
         nbSsQkVNJ2hli4hHvMglTBnU6FViRVITVnILwpkrBfF0DDUkFH59scENvFoboEwdx6eU
         TImhg6+flaG+uj+CRAEfRa7VHvTKJsDfQAgGQ=
Date: Thu, 7 Jan 2010 07:47:56 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100107074756.GB6258@ff.dom.local>
References: <20100106072208.GA6711@ff.dom.local> <4B44E952.5000804@majjas.com> <20100106131044.25b4e500@nehalam> <4B451C31.3000309@majjas.com> <4B454A16.3030909@majjas.com> <4B455C62.6030504@majjas.com> <20100106205343.5460d658@nehalam> <4B4571D5.30002@majjas.com> <4B457711.1040008@majjas.com> <4B458B36.6050509@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B458B36.6050509@majjas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 02:20:22AM -0500, Michael Breuer wrote:
> ...
> Reapplied a couple of earlier patches - still can't do jumbo frames, but  
> the rx errors are gone and speed has improved. Too early to assure that  
> it's stable.
>
> Patches that seem to fix the rx drops (all from Stephen):
> 1) Patch change to tx_init
> 2) Patch to lock netif_device_detach
> 3) Patch to sky2_tx_complete to add netif_device_present test
> Also in the mix: Jarek's alternative 2

BTW, the main difference between alt. 1 and 2 is error notification:
alternative 2 doesn't hide some (most) of drops, so, dependending on
app, there might be more and faster retransmits. (I don't know what
apps used by you (other than dhcp) can depend so much on this.)

>
> With this set and mtu=1500 all seems good - decent if not stellar  
> throughput; no logged errors; no reported packet loss. As before, will  
> leave running and see if anything falls apart.

Good news!

Jarek P.
