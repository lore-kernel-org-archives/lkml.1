Return-Path: <linux-kernel-owner+w=401wt.eu-S935058AbYD1O6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935058AbYD1O6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYD1O6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:58:44 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35801 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933507AbYD1O6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:58:43 -0400
Message-Id: <1209394723.22937.1250267923@webmail.messagingengine.com>
X-Sasl-Enc: 2O3UWmgyH7QBggOJU0zS+djJRvg/8XJP7iGTbW9sXWyP 1209394723
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1209327591.14173.74.camel@brick>
   <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org>
Date: Mon, 28 Apr 2008 16:58:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 13:26:34 -0700 (PDT), "Linus Torvalds"
<torvalds@linux-foundation.org> said:
> On Sun, 27 Apr 2008, Harvey Harrison wrote:
> >
> > No need for a sentinal if we explicitly catch the no bits/all bits set
> > cases, make it clear they are special cases returning size/BITS_PER_LONG.
> 
> These things need to be re-done anyway. David already complained that the 
> thing inlines to something much much too big.
> 
> Let's just make it not be an inline at all.

Hello,

I think that's the wrong way to go about it. The problem that David
Miller pointed out was that the small-bitmap optimization caused an
inliningdisaster. Apparently, the generic version of __ffs is very
big on sparc64. In my opinion the implementation of __ffs should be
made out of line. If you move the wrapper of find_first_bit etc
out of line, all possibilities of optimization will be destroyed.
Better to remove them completely, then.

Greetings,
    Alexander

> 		Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Accessible with your email software
                          or over the web

