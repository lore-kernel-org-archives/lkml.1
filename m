Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbXJOHnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbXJOHnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 03:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbXJOHnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 03:43:40 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:61976 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXJOHnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 03:43:39 -0400
Message-ID: <47131A0B.1050000@cetrtapot.si>
Date: Mon, 15 Oct 2007 09:43:07 +0200
From: "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Samuel Ortiz <samuel@sortiz.org>
Cc: irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [irda-users] [PATCH] irlmp_unregister_link needs to free lsaps
 hashbin
References: <470F6EFB.6010704@cetrtapot.si> <20071013010326.GC8187@sortiz.org>
In-Reply-To: <20071013010326.GC8187@sortiz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Ortiz wrote:
> Hi Hinko,
> 
> On Fri, Oct 12, 2007 at 02:56:27PM +0200, hinko.kocevar@cetrtapot.si wrote:
>> Hi,
>>
>> While testing the mcs7780 based IrDA USB dongle I've stumbled upon
>> memory leak in irlmp_unregister_link(). Hashbin for lsaps is created in
>> irlmp_register_link and should probably be freed in irlmp_unregister_link().
>>
>> Signed-off-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
>>
>> Best regards,
>> Hinko
>>
>> ----
>>
>>
> 
>> --- linux-2.6.23/net/irda/irlmp.c.orig	2007-10-12 14:05:17.000000000 +0200
>> +++ linux-2.6.23/net/irda/irlmp.c	2007-10-12 14:05:41.000000000 +0200
>> @@ -353,6 +353,7 @@ void irlmp_unregister_link(__u32 saddr)
>>  		/* Final cleanup */
>>  		del_timer(&link->idle_timer);
>>  		link->magic = 0;
>> +		hashbin_delete(link->lsaps, (FREE_FUNC) kfree);
> Good catch, but I think the right fix sould be:
> +             hashbin_delete(link->lsaps, (FREE_FUNC) __irlmp_close_lsap);
> 

You're probably right since struct lsap_cb get inserted into the hashbin.

Regards,
Hinko

-- 
ČETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si

