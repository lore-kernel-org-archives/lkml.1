Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYHaX3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYHaX3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 19:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYHaX3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 19:29:25 -0400
Received: from mail.vyatta.com ([216.93.170.194]:41229 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbYHaX3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 19:29:24 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.187
Message-ID: <48BB295A.6050200@vyatta.com>
Date: Sun, 31 Aug 2008 16:29:30 -0700
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
Organization: Vyatta
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>, Dushan Tcholich <dusanc@gmail.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Robert Hancock <hancockr@shaw.ca>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, bridge@lists.linux-foundation.org
Subject: Re: [RFC] bridge: STP timer management range checking
References: <fa.wTMiBcGRgw2fBtdHwtX7y0lkc8s@ifi.uio.no>	<48975BD3.6040709@shaw.ca>	<a08621850808041337k1d1deb6fk78098d9fcd4930dd@mail.gmail.com>	<20080807185802.GA16327@electric-eye.fr.zoreil.com>	<a08621850808101200n220afd2dve58abe67830b7a4f@mail.gmail.com>	<a08621850808110053j5cbf23e6xdf52c9e7440abf19@mail.gmail.com>	<a08621850808291848q5660148fx57d576ecfcbfce8@mail.gmail.com>	<a08621850808310151o143845h195a8658d02270d9@mail.gmail.com>	<20080831100537.6929c51e@extreme>	<20080831104309.780cc01f@extreme> <20080831230247.76b5a193@lxorguk.ukuu.org.uk>
In-Reply-To: <20080831230247.76b5a193@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 31 Aug 2008 10:43:09 -0700
> Stephen Hemminger <shemminger@vyatta.com> wrote:
>
>   
>> The Spanning Tree Protocol timers need to be set within certain boundaries
>> to keep the internal protocol engine working, and to be interoperable.
>> This patch restricts changes to those timers to the values defined in IEEE 802.1D
>> specification.
>>     
>
> Why do we care ? You have to be the network administrator to set values,
> there are cases you may want to be out of the spec and you are
> privileged. The kernel does need to stop things being done which are
> fatal but running around restricting privileged administrators who have
> the ability to bring the network down anyway isn't its job.
>
> Seems bogus extra code to me - stops things working that should be
> allowed too.
>   
The timer configuration is propagated in network protocol, so 
misconfigured Linux box
could survive but effect other devices on the network that are less 
robust. Maybe the
small values would cause some other bridge to crash, go infinite loop, ...
More likely robust devices might ignore our packets (because values out 
of range), leading to
routing loops and other disasters.

The kernel does need to stop administrative settings from taking out a 
network. If someone
has a custom device or other non-standard usage, they can always rebuild 
the kernel and
remove the range check.


