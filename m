Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYALT0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYALT0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 14:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYALTZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 14:25:54 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61412 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYALTZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 14:25:53 -0500
Date: Sat, 12 Jan 2008 13:25:26 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM REMAINS: [sata_nv ADMA breaks ATAPI] Crash on accessing
 DVD-RAM
In-reply-to: <47887982.6050805@mail.ru>
To: Alexander <aledin@mail.ru>
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Message-id: <47891426.1020604@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no>
 <478702C7.80401@shaw.ca> <47887982.6050805@mail.ru>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander wrote:
> Robert Hancock wrote:
>> There's this patch which was intended to fix it:
>>
>> http://lkml.org/lkml/2007/11/22/148
> 
> I applied this patch to 2.6.24-rc7. Now at boot time my DVD-RW is
> normaly detected as:
> 
> sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
> 
> But I cannot mount it. All my attempts failed with
> 
> ISOFS: Unable to identify CD-ROM format.
> 
> With mem<=4098M or sata_nv.adma=0 it still mounts and works ok.

As I wrote, it would appear that somehow the blk_queue_bounce_limit 
setting that the driver has made is not being respected and the block 
layer is still trying to feed it addresses over 4GB. Any ideas anyone?
