Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbZKKKoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbZKKKoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZKKKoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:44:17 -0500
Received: from 1wt.eu ([62.212.114.60]:51018 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZKKKoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:44:17 -0500
Date: Wed, 11 Nov 2009 11:43:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Avi Kivity <avi@redhat.com>, Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091111104359.GJ560@1wt.eu>
References: <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu> <4AF9D8E2.7050205@zytor.com> <20091110220652.GE26633@1wt.eu> <20091111102136.407105f4@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111102136.407105f4@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 10:21:36AM +0000, Alan Cox wrote:
> 
> > So in my opinion, we should have :
> >   - CMOV (for 486, Pentium, C3, K6, ...)
> >   - NOPL (newcomer)
> > 
> > And if we want to extend down to i386 :
> >   - BSWAP (=htonl)
> >   - CMPXCHG (mutex)
> >   - XADD (never encoutered but cheap)
> > 
> > I still have the 2.4 patch for BSWAP, CMPXCHG, CMOV and XADD lying
> 
> If we go that far it needs a lot more thought and probably to use the KVM
> code simply because of all the complexities around prefixes and the like

well, ironically the KVM decoder can decode an infinite string
of prefixes while the very simple and limited one in the patch
I showed did correct checks for invalid cases (multiple segments,
repeated locks, etc...). It would only accept one data size prefix,
one address size prefix, one lock and one segment prefix.

I have nothing against the KVM one, it's just that it's a
full-featured emulator while we were speaking about a 686
emulators for lower-end processors. 98% of the instructions
supported by KVM will never be used for that purpose. This
is where I see a waste. We're comparing 7000 lines of code
supporting 64-bit, real mode, NX, etc... to 400. I fail to
see how we can guarantee that we do it right in that larger
code (and the example above proves it wrong).

And as you said, NX is not an issue on the CPUs we're
targetting.

Regards,
Willy

