Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbXLRScz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbXLRScz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXLRSck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:32:40 -0500
Received: from smtp23.orange.fr ([193.252.22.126]:11293 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbXLRScj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:32:39 -0500
X-ME-UUID: 20071218183237811.13C4B700008F@mwinf2321.orange.fr
Message-ID: <4768123A.7040603@cosmosbay.com>
Date: Tue, 18 Dec 2007 19:32:26 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: James Nichols <jamesnichols3@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>	 <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr>	 <83a51e120712180734i334399dbl51f44fe32d815f7d@mail.gmail.com>	 <Pine.LNX.4.64.0712181704380.4422@fbirervta.pbzchgretzou.qr>	 <83a51e120712180845k6cadf67bn5dd66fb2d3ac72d4@mail.gmail.com>	 <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr>	 <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com>	 <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr> <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
In-Reply-To: <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Nichols a écrit :
>> Here is a purely hypothethical (and in practice unlikely) idea:
>> Java opens up too many sockets (more than you really request) and the
>> kernel, for whatever reason, does not deliver packets to programs
>> which have maxed out their fds. Well it would already help if the
>> java blob was split into multiple blobs (assuming the problem
>> persists), as the best testcase is the smallest possible one. So if
>> it is reproducable without the web blob, great step there.
>>
>>     
>
>
> Right, I don't disagree with you there.  FWIW, I can disable entire
> parts of the application and have already narrowed down reproduction
> of this issue to the 200 threads that make the webservice calls, so it
> doesn't have anything to do with any of the GUI or other background
> services that my application executes.
>
>
> You said:
>
>   
>> Well you could still blame Java. I am sure that if you program was C,
>> the problem could be narrowed down much easier.
>>     
>
> I'm curious to know how this problem would be easier to narrow down if
> it were written in C.
>   
Well... please dont start a flame war :(

Back to your SYN_SENT problem, I suppose the remote IP is known, so you 
probably could post here the result of a tcdpump ?

tcpdump -p -n -s 1600 host IP_of_problematic_peer -c 500

Most probably remote peer received too many attempts from you, and a 
anti DOS mechanism is droping all SYN packets.

Ah well... I remember now that you mentioned tcp_sack setting had an 
effect, so forget the "Most probably..." and give some tcpdump traces :)





