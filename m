Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYHZUp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYHZUp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYHZUpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:45:09 -0400
Received: from smtp2e.orange.fr ([80.12.242.113]:44390 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbYHZUpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:45:08 -0400
X-ME-UUID: 20080826204506745.B5EF4700008F@mwinf2e19.orange.fr
Message-ID: <48B46B48.7030609@cosmosbay.com>
Date: Tue, 26 Aug 2008 22:44:56 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <200808220457.40892.denys@visp.net.lb> <20080826201406.GA24827@2ka.mipt.ru>
In-Reply-To: <20080826201406.GA24827@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov a écrit :
> On Fri, Aug 22, 2008 at 04:57:40AM +0300, Denys Fedoryshchenko (denys@visp.net.lb) wrote:
>> I have loaded router (~650 Mbps In+Out), based on 2xAMD Opteron 248, Sun Fire 
>> X4100. HPET timer available (TSC seems not available on this platform).
>> Network interfaces is onboard, connected over PCI-X.
>>
>> Right now i am using only one processor, cause using only one interface and 
>> interrupts stick to it. Other is almost not used.
>> At peak time i notice in mpstat, that this processor is almost "dead", and if 
>> i run minor application consuming resources - ping over this router will be 
>> terrible. For me it is clear - system overloaded. I did oprofile, and here is 
>> result (at low load time, but at peak time it is very similar).
> 
> Do you have any packet sockets in this system? Like running dhcp daemon?
> 

Another way to see this problem can be to start a sniffer on the machine, even with a 
restrictive pcap filter, to check if performance change or not. (It should decrease)

For example, I believe that running "ping" could have the same effect
(increasing netstamp_needed variable : every incoming packet has to be timestamped)

So beware of pings, traceroute and other networking tools...



