Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYCOWqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYCOWqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 18:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYCOWqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 18:46:38 -0400
Received: from dell.benran.ru ([83.149.196.126]:53382 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752367AbYCOWqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 18:46:37 -0400
Date: Sun, 16 Mar 2008 01:46:36 +0300 (MSK)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: David Brownell <david-b@pacbell.net>
cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       Rene Herman <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org
Subject: Re: ehci-hcd affects hda speed
In-Reply-To: <alpine.LFD.1.00.0803101303240.4772@nev.ubzr>
Message-ID: <alpine.LFD.1.00.0803160054360.23451@nev.ubzr>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <47CEC816.6000808@keyaccess.nl> <5a4c581d0803051203s1a0048c2u5f10b3eb442cfafb@mail.gmail.com> <200803051303.46275.david-b@pacbell.net> <alpine.LFD.1.00.0803062244010.10693@nev.ubzr>
 <alpine.LFD.1.00.0803101303240.4772@nev.ubzr>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


LAM> Also, does anyone have a VT6212L datasheet? Unfortunately, Google
I have eventually found it. An enlightening reading, really. If I 
understood all words, I mean :-). Particularly, what does "MAC turn around 
time" stand for with respect to EHCI? I would appreciate some reference, 
thanks.

  On Wed, 5 Mar 2008 at 5:19pm, Rene Herman wrote:

RH> It was diagnosed to the VT6212L doing decidedly weird things with
RH> toggling the Async bit and tying up the bus.
Yes, it really looks like the chip owns the bus when it shouldn't. Suppose 
VT6212L has damaged its brains somehow. Can we fix this by ignoring its 
requests unless they are legitimate? I mean make the driver enable bus 
mastering only for short periods when the controller is expected to do 
something useful. It is easy (I have already done myself) to implement for 
asynchronous schedule, but there's still periodic schedule. Is it 
possible? How? Please advise.

Being positive, I didn't have much time to play with it yet, but changing 
the bit 5 (EHCI sleep time select:  0=1us 1=10us) of register 0x4B seems 
to resolve my own problem. I wonder if this is going to help others 
(Alessandro?):

setpci -s 00:09.2 4b.b=29

[don't forget to adjust the device address].

-L
