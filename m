Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYDSIcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYDSIcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 04:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbYDSIby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 04:31:54 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:55841 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbYDSIbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 04:31:53 -0400
Message-ID: <4809ADF7.9040604@free.fr>
Date: Sat, 19 Apr 2008 10:31:51 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080313 Iceape/1.1.9 (Debian-1.1.9-1)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Alex Dubov <oakad@yahoo.com>
Subject: Re: Smartmedia/xd card support - request for comments
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Fri, 18 Apr 2008, Alex Dubov wrote:
> 
> First off, can you please use a mail client which does line breaks at
> around 78 chars ?
>  
>> As you understand, both smartmedia media and hosts follow certain
>> spec (publicly available here:
>> http://www.ssfdc.or.jp/spec/index_e.htm, basic registration
>> required). xd card spec is almost identical, adding some cosmetic
>> features and restrictions (such as prohibition of single page
>> programming). This means, that smartmedia access protocol can be
>> abstracted out in the reader-independent way. You can seen in the
>> xd_card_blk.c that it can operate both completely dumb controllers,
>> while taking protocol shortcuts (using host->caps) to accommodate
>> smarter readers (the only feature currently not there is
>> adapter-side page copy - it can be easily added under FBD_COPY
>> clause in xd_card_trans_req). The backend itself (jmb38x_xd.c)
BTW some bare nand flash have support to page copy (there is some issue 
because of no ecc checking during the copy). So the support of this 
could be usefull in mtd.


> Having a separate driver infrastructure for clever controllers, which
> provide only semi raw access to the FLASH chip is fine simply because
> such controllers do not fit into the MTD layer.
I wonder if mtd shouldn't modified to handler more clever controller :
I saw some raw nand controller where you can program a batch of 
command/read/write/ecc checking (that work on a internal RAM of the 
controller (and may be use DMA)) and all you have to do is to wait the 
controller do the job.
These controllers are very hard to integrate in current nand layer 
because it is very low level controller oriented.

>> > Correct.  Erase() is the only callback-based function and every single
>> > driver implements it synchronous anyway.  Improving this situation is
>> > needed for mtd's own sake anyway.  Either that or replacing mtd with
>> > something else, likely the block device code.
>>
Current mtd have other limitations (4GB limit fix, dma buffer, ...),
but in the end it should be fixed.


Matthieu

PS : by using mtd layer you :
- will make improvement that will be useful for everybody
- will use a stack that have been and will be well tested
- will have some controller drivers for free
- will have nand fs for free (for people that don't trust FTL).
- may be provide interesting FTL for raw nand controller
