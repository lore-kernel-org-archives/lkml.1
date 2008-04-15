Return-Path: <linux-kernel-owner+w=401wt.eu-S1763835AbYDOQG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763835AbYDOQG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYDOQGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:06:48 -0400
Received: from host64.cybernetics.com ([70.169.137.4]:4582 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYDOQGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:06:47 -0400
X-Greylist: delayed 1638 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Apr 2008 12:06:47 EDT
Message-ID: <4804CC2F.6030403@cybernetics.com>
Date: Tue, 15 Apr 2008 11:39:27 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>,
       netdev <netdev@vger.kernel.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
References: <47BA0984.2070306@cybernetics.com> <1203381120.13495.78.camel@dell> <20080218.163554.74130592.davem@davemloft.net> <1203383046.13495.87.camel@dell> <47BB00EC.3010607@cybernetics.com> <1203448265.13495.95.camel@dell> <47BB54C2.6090501@cybernetics.com> <20080220034515.GC22703@gondor.apana.org.au> <47BC44E2.9060301@cybernetics.com> <20080415001207.GA11852@localdomain>
In-Reply-To: <20080415001207.GA11852@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Carlson wrote:
> Hi Tony.  Sorry for the radio silence.
>
> Michael and I have discussed this problem a bit.  Another possibility is
> that the chip may be having difficulty with non-dword aligned TX buffers.
> Since we already know the RX side has the same problem, it isn't so
> far-fetched to think that perhaps it can affect the TX side too.  Can
> you give the following patch a try and see if the corruption still
> happens?
>
>   

Thanks, your patch fixes the problem (tested on 2.6.24.4).  However, I
had to change "(skb->mac_header & 3)" in your patch to "((long)
skb->mac_header & 3)" since mac_header is a pointer rather than an int
on 32-bit systems.

Tested-by: Tony Battersby <tonyb@cybernetics.com>

