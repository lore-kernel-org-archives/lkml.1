Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbZKJUyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbZKJUyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZKJUyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:54:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46206 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065AbZKJUyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:54:52 -0500
Date: Tue, 10 Nov 2009 21:54:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110205445.GB1407@ucw.cz>
References: <20091110052711.GA15338@1wt.eu> <4AF9020C.90108@zytor.com> <4AF9435F.2070103@redhat.com> <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110201602.GA26633@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Indeed, but there is a difference between [cmpxchg, bswap, cmov, nopl]
> on one side and [sse*] on the other : distros are built assuming the
> former are always available while they are not always. And the
> distro

Well, fix the distros... 

> which make the difference have to provide an dedicated build for earlier
> systems just for compatibility. SSE*, 3dnow* etc... are only used by a
> handful of media players/converters/encoders which are able to detect
> themselves what to use and already have the necessary fallbacks because
> these instruction sets vary too much between processors and vendors.
> 
> One could argue that cmpxchg/bswap/xadd are supported by 486 and that
> implementing them for 386 is almost useless now (though it costs almost
> nothing to provide them, I did a few years ago). 
> 
> CMOV/NOPL are rarely used, thus have no reason to cause a massive
> performance drop, but are frequent enough (at least cmov) for almost

*One* CMOV in the inner loop will make your performance go down 20x.

      	      	  	     	       	    		   	Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
