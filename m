Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0BAKre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:47:34 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57043 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0BAKrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:47:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=STZ1gbk886V569Tu39N0IkAJv2lw8HcL1653crT9V40c0mp3pxbn+PrqxHmua/woY2
         Uh0/k4P99/jry1RDZMyHmUVX2KQiEeobf8Ldl8jka2+7b1EgkTy/B3e/cCbjbx5kYp1X
         fxz9bIjDXaEZlwQh9bmHhzEBkwmHEOxIEl8lM=
Date: Mon, 1 Feb 2010 10:47:22 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: [PATCH] sky2:  receive dma mapping error handling
Message-ID: <20100201104722.GA12329@ff.dom.local>
References: <4B6216B9.1010802@majjas.com> <20100128153643.0fca3c51@nehalam> <4B645EF4.4050701@majjas.com> <20100131003449.GA11935@del.dom.local> <4B650D53.2010607@majjas.com> <4B65D0F9.2020602@majjas.com> <4B65FD12.7090101@majjas.com> <20100131221835.GA3317@del.dom.local> <4B661E22.8090907@majjas.com> <4B6657DB.3010008@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6657DB.3010008@majjas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 11:26:03PM -0500, Michael Breuer wrote:
> FYI - tried generating lots of extra tx traffic... found a way to  
> generate the rx status messages on demand:
>     ping -i .0000001 -s 8000 -t 2 <host> >/dev/null
>
> Yields:
> Jan 31 23:08:07 mail kernel: sky2 eth0: rx error, status 0x1f6a0010  
> length 1518
...
> Jan 31 23:08:12 mail kernel: net_ratelimit: 316 callbacks suppressed
> etc.
...
> Understanding that the other side is out of spec, I'd still wonder why  
> the sky2 driver generates rx errors. Perhaps overruns should be tossed  
> silently... by the hardware if possible.

Of course it's a matter of taste, but it seems such errors shouldn't
be tolerated in a local network. I'd rather prefer doing them more
explicit (like e.g. some other kind of length errors).

Jarek P.
