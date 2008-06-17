Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbYFQEYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbYFQEYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 00:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYFQEX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 00:23:58 -0400
Received: from mout.perfora.net ([74.208.4.196]:57401 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYFQEX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 00:23:58 -0400
Date: Mon, 16 Jun 2008 23:22:54 -0500 (CDT)
From: "R.L. Horn" <lists@eastcheap.org>
X-X-Sender: rlhorn@hani.compact.internal
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
In-Reply-To: <20080616111329.3ae97879@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LNX.1.00.0806162306400.10919@hani.compact.internal>
References: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal> <20080614102900.6830ed46@lxorguk.ukuu.org.uk> <alpine.LNX.1.00.0806150032050.1283@hani.compact.internal> <20080616111329.3ae97879@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX1/4lzecdYTnNg6rvLR5QyzVC3RoeE4xOpEvgdd
 eTew+sYFzUxq3tm0so7vgjlkUjMGlDTHqlgBaZoI40TF2q8U1h
 ntgZC7RahCaGPmmm8/Htg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008, Alan Cox wrote:

> Whatever it implies the behaviour should not have changed between 2.6.24
> and 2.6.25. Nobody AFAIK sat down and decided to change it.

And, besides, I've gotten reports that the usb-serial drivers still behave 
the same as with 2.6.24.

It looks like the call to tty_termios_encode_baud_rate() in 
drivers/serial/8250.c is the culprit.  If I comment it out, everything 
appears to go back to normal (seemingly with no undesired side effects).

Why the call is there (it didn't replace anything else in the 2.6.24.7 
version of 8250.c, though it did in serial_core.c) remains a mystery to 
me.
