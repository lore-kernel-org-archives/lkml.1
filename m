Return-Path: <linux-kernel-owner+w=401wt.eu-S965827AbXCLNAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965827AbXCLNAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 09:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965828AbXCLNAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 09:00:08 -0400
Received: from khc.piap.pl ([195.187.100.11]:42072 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965778AbXCLNAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 09:00:05 -0400
To: "Tosoni" <jp.tosoni@acksys.fr>
Cc: "Jean-Pierre TOSONI" <TOSONI@acksys.local>,
       "'Carl-Daniel Hailfinger'" <c-d.hailfinger.devel.2006@gmx.net>,
       "'Robin Getz'" <rgetz@blackfin.uclinux.org>,
       "'Oleksiy Kebkal'" <kebkal@gmail.com>,
       "'Mike Frysinger'" <vapier.adi@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <linux-serial@vger.kernel.org>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
References: <000001c76487$f7efd100$2e01a8c0@acksys.local>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 12 Mar 2007 13:59:55 +0100
In-Reply-To: <000001c76487$f7efd100$2e01a8c0@acksys.local> (Tosoni's message of "Mon, 12 Mar 2007 10:22:33 +0100")
Message-ID: <m34poq39dg.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Tosoni" <jp.tosoni@acksys.fr> writes:

> It has always been the standard for all modems.

Look, I've been using various modems for many years, starting with
self-made 300 bps one and there were basically 3 options:
- no flow control at all (no buffering etc), RTS/CTS disabled/missing,
- XON/XOFF flow control, RTS/CTS disabled/missing,
- RTS/CTS handshaking with RTS = modem can send to computer (with
  option to ignore RTS) and CTS = computer can send to modem.

> The mistake comes from the
> fact that the serial ports has been used extensively to drive things which
> are *not* modems (say, printers and VT100 consoles on Unix systems). Such
> devices did not need the standard-specified RTS function.

VT100 and printers are DTE, connections between DTE (without help
of DCE) are obviously non-standard.

> CCITT V24 says about RTS: "...this signal drives the DCE and sets it to
> transmit data..." (translated from french)
> CCITT V24 does not constraint the DCE to being half or full duplex.
> CCITT V24 says nothing about using RTS to handle flow control.

Circuit 105 - Request to send
Direction: To DCE
Signals on this circuit control the data channel transmit function
of the DCE. The ON condition causes the DCE to assume the data channel
transmit mode. The OFF condition causes the DCE to assume the data
channel non-transmit mode, when all data transferred on circuit 103
have been transmitted.

What do you think are "data channel transmit mode" and "non-transmit"
mode? Obviously the standard doesn't know if it's a radiomodem, RS-485
style multipoint bus or something else but it's clearly half-duplex -
full-duplex devices are always in "transmit" and "receive" mode
simultaneously.

Does your modem drop carrier when RTS goes?

V.24 assumes DTE is always able to receive data. While it's probably
the case with PC and Linux, it may not be true with all DTE. With
strict V.24 DTE has not way to say "I can't take data, stop
transmitting". Now imagine connecting a serial printer to a PC
with a pair of DCE.

>> I've seen such devices quite recently, perhaps ~ 10 years ago.
>> OTOH I think even "current" PC BIOSes use such signaling.
>
> Even Windows implements the CCITT view of RTS, via a flag named "RTS_TOGGLE"

Great, meanwhile we don't have it here, but that only means nobody
is really interested in it.

>> For such signaling, it would perhaps be better to invent another flag,
>> similar to CRTSCTS. The driver would, of course, need some real code
>> for that.
>
> Another flag would help to drive modems, yes.

Which modems, exactly? Normal modems work perfectly fine with current
CRTSCTS and this RTS toggling could only confuse them.
A flag alone is no help for half-duplex devices, they would need
a complete handshaking code.
-- 
Krzysztof Halasa
