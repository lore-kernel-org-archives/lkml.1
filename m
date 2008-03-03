Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYCCWzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYCCWzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYCCWz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:55:27 -0500
Received: from ms4-1.1blu.de ([213.83.63.61]:49194 "EHLO ms4-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758282AbYCCWzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:55:25 -0500
X-Greylist: delayed 6721 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Mar 2008 17:55:25 EST
Message-ID: <47CC67F5.6030505@razik.name>
Date: Mon, 03 Mar 2008 22:04:53 +0100
From: Lukas Razik <linux@razik.name>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417 FreeBSD/i386
X-Accept-Language: de-de, en-us, en
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Ethernet over Kernel Sockets
References: <47C870FD.4000808@razik.name> <20080302104650.GC3861@ucw.cz>
In-Reply-To: <20080302104650.GC3861@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Con-Id: 21979
X-Originating-IP: 78.50.93.146
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pavel!

Thanks for your answer!

>>As you know, some network cards doesn't have a 'eth' 
>>interface under linux.
>>Because of that I'm developing a net_device based driver 
>>which doesn't transmit and receive directly through a 
>>real network card but through UDP kernel sockets.
> 
> What is it good for?

It's good for network cards which have a socket implementation but no 
'eth' interface which is needed by some applications...

>>The interesting thing is, that I always get PingPongs of 
>>1ms (= one jiffie). Although if I measure with 100MBit- 
>>or other non-Ethernet cards.
> 
> Try increasing HZ :-)... or maybe it is a gigabit interrupt mitigation
> issue?

Yes, that would have been a nice solution for an OS-freak (like me and 
sure like you) but there are also other people :-/ who want to run more 
than the really nice linux kernel on their machines... ;-)))

The performance brake was the kernel thread for receiving packets. My 
solution are socket callbacks.
The idea I've got from someone of the kernelnewbies mailing list and 
some other people. Now I've PingPong times of ~30µsec (with Ethernet 
over Sockets over Ethernet, which natively has ~23µsec).

For interested people:
http://mail.nl.linux.org/kernelnewbies/2008-03/msg00005.html

Regards,
Lukas
