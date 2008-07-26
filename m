Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbYGZUFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbYGZUFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 16:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757661AbYGZUFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 16:05:48 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:61094 "EHLO
	pd6mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757548AbYGZUFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 16:05:47 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=LwqqXO8vmwz-oTbB52kA:9 a=hiVO5_Fapn3ivAYGWUYA:7 a=ApV2mn0ZkfG6H9doiD5NSBkI9ZsA:4 a=5OxXCWZL5BMA:10 a=bwVuZ38C_bkA:10
Message-ID: <488B8396.6000909@shaw.ca>
Date: Sat, 26 Jul 2008 14:05:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: What to do with `kswapd0: page allocation failure. ` ?
References: <fa.D09/4X9DRMh7IIolk0FWx9V7A2k@ifi.uio.no> <fa.t1205kREOn3zo/ARD/J1XRupvUU@ifi.uio.no> <fa.JR0D/ya5niKzRp9PulS5LvnbhqQ@ifi.uio.no> <fa.ifMjE6bNVSEOY+bMgRSeQMCIhlI@ifi.uio.no>
In-Reply-To: <fa.ifMjE6bNVSEOY+bMgRSeQMCIhlI@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> KOSAKI Motohiro wrote:
>>>> no bug.
>>>> this stack trace speak to
>>>>
>>>> 1. memory pressure increased
>>>> 2. kswapd ran
>>>> 3. network packet received
>>>> 4. interrupt for network happend
>>>> 5. but can't allocate memory for network buffer(skb).
>>>> 6. Then, packet dropped
>>>> 7. Then, warning happend.
>>>>
>>>> your network peer may resend the same packet after few times.
>>>> no problem.
>>> Thanks.
>>> This was on a 4GB AMD X86_64 machine running Fedora 9.
>>> The memory was not loaded that much. (~2 GB)
>>> Or was the (largish) file being cached, filling up RAM?
>> maybe..
> 
> I can reproduce this by wget'ing a 5.xGB file from my MythTV box.
> The receiving end is a Fedora 9, AMD x86_64 box with an Abit m56s-s3
> board using nVidia Corporation MCP65 Ethernet (rev a3).
> It uses the forcedeth: Reverse Engineered nForce ethernet driver.
> Version 0.61.
> 
> Should I forward this info to someone so this could be fixed?
> Someone doing the kernel memory management?
> Or forcedeth?
> Or?
> 
> Please let me know.

The fact you're using jumbo frames makes this more noticeable, since it 
needs a 9000 byte chunk of memory to receive the packet, which means 
that it needs to allocate a 16KB chunk of memory. This means that even 
if memory is not full, it can be that no sufficiently large chunk of 
memory is available.

Quite likely something could be done to improve this, yes..
