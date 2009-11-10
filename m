Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZKJWBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZKJWBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbZKJWBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:01:44 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35070 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbZKJWBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:01:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=eV3oupAcaUZ7hTLLTl6WBHVsA3Q+WfRbimn6ipiqQPP1M2eLvzbE6bi95VPx4akic5
         7UfMpUPXKQfDjD99TsyDqTawf05jIbDocBUy7jaN2zstW/TzR9jvyRMTkdfa5MXS9sf5
         MGRwlUhfB5WZbqysZdf0eQWsaXwELutO2jEr8=
MIME-Version: 1.0
In-Reply-To: <20091110205445.GB1407@ucw.cz>
References: <20091110052711.GA15338@1wt.eu> <4AF9435F.2070103@redhat.com> 
	<20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> 
	<20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> 
	<4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> 
	<20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz>
From: Matteo Croce <technoboy85@gmail.com>
Date: Tue, 10 Nov 2009 23:01:26 +0100
Message-ID: <40101cc30911101401o79a62066qf87be897abbb354e@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Pavel Machek <pavel@ucw.cz>
Cc: Willy Tarreau <w@1wt.eu>, "H. Peter Anvin" <hpa@zytor.com>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 9:54 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> Indeed, but there is a difference between [cmpxchg, bswap, cmov, nopl]
>> on one side and [sse*] on the other : distros are built assuming the
>> former are always available while they are not always. And the
>> distro
>
> Well, fix the distros...

$ objdump -d libflashplayer.so |grep cmov -c
10

and ask the companies to fix their binaries too?

>> which make the difference have to provide an dedicated build for earlier
>> systems just for compatibility. SSE*, 3dnow* etc... are only used by a
>> handful of media players/converters/encoders which are able to detect
>> themselves what to use and already have the necessary fallbacks because
>> these instruction sets vary too much between processors and vendors.
>>
>> One could argue that cmpxchg/bswap/xadd are supported by 486 and that
>> implementing them for 386 is almost useless now (though it costs almost
>> nothing to provide them, I did a few years ago).
>>
>> CMOV/NOPL are rarely used, thus have no reason to cause a massive
>> performance drop, but are frequent enough (at least cmov) for almost
>
> *One* CMOV in the inner loop will make your performance go down 20x.

Still better than a browser crashing for a SIGILL
