Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYLVUQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYLVUQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYLVUQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:16:12 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:58717 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754023AbYLVUQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:16:11 -0500
Message-ID: <494FF5A4.9010809@ru.mvista.com>
Date: Mon, 22 Dec 2008 23:16:36 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O   support
 properly
References: <494A5BBF.8000807@inf.tu-dresden.de>	<494A837A.50801@garzik.org> <20081218181015.2e160d5c@lxorguk.ukuu.org.uk> <494C512B.6090304@shaw.ca> <494CF231.4020000@ru.mvista.com>
In-Reply-To: <494CF231.4020000@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>> This seems like a risky assumption...

>>> Its wrong on various counts

>>> - ata_id_major_version can't tell early ATA versions apart
>>> - on anything later than the early ISA IDE paddles (the ones that
>>> basically were just bus decoders) its invisible to the drive

>>> Except for legacy ISA bus controllers (and even there it is 
>>> questionable) I would favour simply ignoring it.

>> 32-bit IO wouldn't work on any ISA controller, would it? What happens 
>> if you do 32-bit IO port access on something on the ISA bus?

>   TTBOM, depending on what's driven by device on -IOCS16, this will 
> translate into 2, 3, or 4 cycles at the successive addresses. In case of 
> the IDE data register, this should translate into one 16-bit cycle at 
> 0x1x0, one 8-bit cycle at 0x1x1, and one 8-bit cycle at 0x1x2 which is 
> of course not what anybody would want...

    The 8-bit cycles would be at ports 0x1x2 and 0x1x3, of course. :-)

MBR, Sergei
