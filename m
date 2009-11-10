Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZKJWKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZKJWKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZKJWKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:10:20 -0500
Received: from 1wt.eu ([62.212.114.60]:50940 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZKJWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:10:19 -0500
Date: Tue, 10 Nov 2009 23:10:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: Matteo Croce <technoboy85@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091110221008.GF26633@1wt.eu>
References: <4AF9435F.2070103@redhat.com> <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <40101cc30911101401o79a62066qf87be897abbb354e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc30911101401o79a62066qf87be897abbb354e@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 11:01:26PM +0100, Matteo Croce wrote:
> On Tue, Nov 10, 2009 at 9:54 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> Indeed, but there is a difference between [cmpxchg, bswap, cmov, nopl]
> >> on one side and [sse*] on the other : distros are built assuming the
> >> former are always available while they are not always. And the
> >> distro
> >
> > Well, fix the distros...
> 
> $ objdump -d libflashplayer.so |grep cmov -c
> 10

Good point !
Same here, only 2 of them won't work on C3 (the first ones) :

  7e3a7c:       0f 4d 45 c8             cmovge -0x38(%ebp),%eax
  7e3b4d:       0f 4d 45 c8             cmovge -0x38(%ebp),%eax
  7e97b3:       0f 4c c2                cmovl  %edx,%eax
  7e9823:       0f 4c c2                cmovl  %edx,%eax
  7eb884:       0f 4c c2                cmovl  %edx,%eax
  7eb91d:       0f 4c c2                cmovl  %edx,%eax
  8095d7:       0f 42 ca                cmovb  %edx,%ecx
  80997a:       0f 42 ca                cmovb  %edx,%ecx
  809a4a:       0f 42 ca                cmovb  %edx,%ecx
  80a5cb:       0f 42 ca                cmovb  %edx,%ecx

clearly worth emulating in my opinion.

Willy

