Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132Ab0AJWVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0AJWVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067Ab0AJWVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:21:37 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:58865 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab0AJWVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BgXhrWg5K+ooOLJbB01MIgrFxBImRsiLkL0e2LYiFo/potxrZbdj/L6x46vuechpR1
         H0SP8znPr4bFDAokJ/1IuEJRUm5sLlgm9+LlTblwl0NsmHf/JcfANZC7WIJ2IADxIDxH
         It8CB7hl/8h+svVb+KsBaGAsMbLzZRHlKowns=
Date: Sun, 10 Jan 2010 23:21:29 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: mbreuer@majjas.com, shemminger@vyatta.com, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-2.6 resent] af_packet: Don't use skb after
 dev_queue_xmit()
Message-ID: <20100110222129.GA3606@del.dom.local>
References: <20100109123827.GB4386@del.dom.local>
 <20100110.135135.237364018.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110.135135.237364018.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 01:51:35PM -0800, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Sat, 9 Jan 2010 13:38:27 +0100
> 
> > tpacket_snd() can change and kfree an skb after dev_queue_xmit(),
> > which is illegal.
> > 
> > With debugging by: Stephen Hemminger <shemminger@vyatta.com>
> > 
> > Reported-by: Michael Breuer <mbreuer@majjas.com>
> > Tested-by: Michael Breuer <mbreuer@majjas.com>
> > Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
> > Acked-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> Jarek, if this code path triggers, it will deadlock the
> send ring with your changes.
> 
> We will now leave the ring packet status in the "SENDING" state.
> 
> That's not right.

No, the destructor of this skb, tpacket_destruct_skb(), will clean
this. (Just like for other skbs kfreed during dev_queue_xmit().)

Jarek P.
