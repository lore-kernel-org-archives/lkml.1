Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbXLMNpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbXLMNpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbXLMNox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:44:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:26368 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbXLMNow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:44:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Yxi7u+INwvWzyraZ9Ai6U/7p2ap/PqybC2eJHVhNZ71u6VTi70l3bTwxDttNENFYPgMpBRqv9ekETMqSJa+4+6nWK2zqwwyHOme9gQzWprSIZyIh8ihyOIHOusDFo58UP/BxKtN4gxk72pJ2+8yeFkq4Ge7WYlMXWgsrCwgXfog=
Date: Thu, 13 Dec 2007 14:49:53 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: David Miller <davem@davemloft.net>, gallatin@myri.com,
       joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [RFC] net: napi fix
Message-ID: <20071213134953.GA3806@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47602B77.2090202@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-12-2007 19:41, Kok, Auke wrote:
> David Miller wrote:
>> From: Andrew Gallatin <gallatin@myri.com>
>> Date: Wed, 12 Dec 2007 12:29:23 -0500
>>
>>> Is the netif_running() check even required?
>> No, it is not.
>>
>> When a device is brought down, one of the first things
>> that happens is that we wait for all pending NAPI polls
>> to complete, then block any new polls from starting.
> 
> I think this was previously (pre-2.6.24) not the case, which is why e1000 et al
> has this check as well and that's exactly what is causing most of the
> net_rx_action oopses in the first place. Without the netif_running() check
> previously the drivers were just unusable with NAPI and prone to many races with
> down (i.e. touching some ethtool ioctl which wants to do a reset while routing
> small packets at high numbers). that's why we added the netif_running() check in
> the first place :)
> 
> There might be more drivers lurking that need this change...
> 

As a matter of fact, since it's "unlikely()" in net_rx_action() anyway,
I wonder what is the main reason or gain of leaving such a tricky
exception, instead of letting drivers to always decide which is the
best moment for napi_complete()? (Or maybe even, in such a case, they
should call some function with this list_move_tail() if it's so
useful?)

Regards,
Jarek P.
