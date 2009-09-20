Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZITRRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZITRRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZITRRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:17:37 -0400
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:49666 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754693AbZITRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:17:36 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net 642273B2B84
Message-ID: <4AB663B0.9070600@arcor.de>
Date: Sun, 20 Sep 2009 20:17:36 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Poor desktop responsiveness with background I/O-operations
References: <4AB59CBB.8090907@datenparkplatz.de> <20090920080728.73bfe2a1@infradead.org> <4AB5ECD0.7010903@datenparkplatz.de>
In-Reply-To: <4AB5ECD0.7010903@datenparkplatz.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please don't strip the CC list when you reply.  Use the "Reply to all" 
functionality of your mail client and keep all CCs.)

On 09/20/2009 11:50 AM, Ulrich Lukas wrote:
> Arjan van de Ven wrote:
>> can you try the following two things?
>>
>> echo 4096>  /sys/block/sda/queue/nr_requests
>> for i in `pidof kjournald` ; do ionice -c1 -p $i ; done
>
> I tried this just now, but it doesn't change things much. I can do a
> more testing later today.
>
>
>> I assume you're using CFQ.
>
> Yes, it's CFQ. (see .config of my previous posting)
>
> Filesystem is EXT4.

I can also confirm total lock-up when copying a big file (Intel Core 2 
Duo, Intel X38 chipset).  Everything locks-up for several seconds during 
the copying.  I'm also on ext4.  I've been told on various mailing lists 
that this is normal, expected and unavoidable so I pretty much think the 
only solution is to avoid heavy I/O :P
