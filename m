Return-Path: <linux-kernel-owner+w=401wt.eu-S1767256AbXDTUgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767256AbXDTUgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031044AbXDTUgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:36:14 -0400
Received: from homer.mvista.com ([63.81.120.155]:48531 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030866AbXDTUf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:35:56 -0400
Message-ID: <46292464.90403@ru.mvista.com>
Date: Sat, 21 Apr 2007 00:36:52 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] ide: make ide_hwif_t.ide_dma_host_on void
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain> <20070119003220.14846.14258.sendpatchset@localhost.localdomain> <460800A8.4050501@ru.mvista.com>
In-Reply-To: <460800A8.4050501@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, once I wrote:

>> [PATCH] ide: make ide_hwif_t.ide_dma_host_on void
 
>> * since ide_hwif_t.ide_dma_host_on is called either when 
>> drive->using_dma == 1
>>   or when return value is discarded make it void, also drop "ide_" prefix
>> * make __ide_dma_host_on() void and drop "__" prefix

>    BTW, it would also make sense to make hwif->ide_dma_timeout() and 
> hwif->ide_dma_lostirq void too (and possibly drop the ide_ prefix). 
> Their results are *explicitly* ignored.

   I've started preparing the patches and found out that aec62xx has completely bogus ide_dma_timeout() -- the same as ide_dma_lostirq() and it doesn't even call __ide_dma_timeout()... :-/
   Don't know whether to deal with this in a separate patch...

MBR, Sergei
