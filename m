Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbYGIPrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbYGIPrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYGIPrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:47:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37430 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbYGIPrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:47:23 -0400
Message-ID: <4874DD72.2050903@garzik.org>
Date: Wed, 09 Jul 2008 11:46:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Howells <dhowells@redhat.com>, alan@redhat.com,
       Markus.Lidel@shadowconnect.com, vvs@sw.ru, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
References: <20080709113547.19235.15424.stgit@warthog.procyon.org.uk> <20080709154753.3dcfacab@the-village.bc.nu>
In-Reply-To: <20080709154753.3dcfacab@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Wed, 09 Jul 2008 12:35:47 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
>> Mark i2o config broken on 64-bit platforms as it generates these:
>>
>> In file included from drivers/message/i2o/config-osm.c:39:
>> drivers/message/i2o/i2o_config.c: In function 'i2o_cfg_passthru':
>> drivers/message/i2o/i2o_config.c:889: warning: cast to pointer from integer of different size
>> drivers/message/i2o/i2o_config.c:945: warning: cast to pointer from integer of different size
>>
>> which are apparently non-trivial to fix (eg: inserting a cast through unsigned
>> long is not correct according to Linus).  This would be due to struct
>> sg_simple_element only having a 32-bit addr_bus value.
>>
>> There are also a number of "TODO 64bit fix" comments.
>>
>> Signed-off-by: David Howells <dhowells@redhat.com>
> 
> 
> NAK - it appears to be broken for 64bit user space only

Agreed.

That was the conclusion when I joined the cast of thousands who tried to 
kill this warning, and found that out...

	Jeff




