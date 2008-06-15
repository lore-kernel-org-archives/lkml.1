Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYFOHFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYFOHFG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 03:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbYFOHEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 03:04:55 -0400
Received: from mout.perfora.net ([74.208.4.194]:54427 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645AbYFOHEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 03:04:54 -0400
Date: Sun, 15 Jun 2008 02:04:42 -0500 (CDT)
From: "R.L. Horn" <lists@eastcheap.org>
X-X-Sender: rlhorn@hani.compact.internal
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
In-Reply-To: <20080614102900.6830ed46@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LNX.1.00.0806150032050.1283@hani.compact.internal>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal> <20080614102900.6830ed46@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/NGahJWxwyCtY3MvpY5C4JocZa7rqmxMaUZ2D
 V/IEjkOEcHtUyR2Q8jDKglVIM1JpskQYHgt9Xz0BXrXAWrwA+S
 qYYJx2Vk0rNkLfdvFdaJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jun 2008, Alan Cox wrote:

> What happens after you go from B0->Banythingelse should depend on the
> termios settings at that point. This sounds like a bug therefore.
>
> If you want that behaviour intentionally set B0, after this termios
> call then set CLOCAL before changing the baud back.

I'm not seeing any change in behavior with different combinations of 
CLOCAL.  As it happens, minicom sets CLOCAL first thing so as to keep 
SIGHUP signals from being generated.

But, then, what is the relationship between CLOCAL and DTR/RTS supposed to 
be?  Presumably, it should prevent a SIGHUP from being raised when DSR 
goes low, but beyond that, it all seems rather ill-defined.  Throw in B0, 
which the SUS strongly implies should unconditionally lower DTR and RTS, 
and the CRTSCTS flag, and the waters really get murky.  It looks to me 
like the only thing you can say for certain is that CLOCAL will cause DSR 
to be ignored...and for anything else you're on your own.

Mind you, all this just suggests that POSIX kinda sucks, which is hardly 
an earth-shattering revelation.

> I'll take a look at this next week.

It would be much appreciated.  Thanks.
