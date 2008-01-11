Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbYAKFsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbYAKFsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 00:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYAKFsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 00:48:08 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:47071 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYAKFsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 00:48:07 -0500
Date: Thu, 10 Jan 2008 23:46:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM REMAINS: [sata_nv ADMA breaks ATAPI] Crash on accessing
 DVD-RAM
In-reply-to: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no>
To: Alexander <aledin@mail.ru>
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Message-id: <478702C7.80401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander wrote:
> Hello!
> 
> The problem described at https://bugzilla.redhat.com/show_bug.cgi?id=351451 and
> at http://ubuntuforums.org/showthread.php?t=655772 and supposedly fixed by the
> patch http://kerneltrap.org/mailarchive/linux-kernel/2007/11/25/445094 is still
> there. I have compiled 2.6.24-rc7 kernel and booted my PC with it just to find
> out that my SATA DVD-RW is

There's this patch which was intended to fix it:

http://lkml.org/lkml/2007/11/22/148

which hasn't been merged yet. I see now that there was some further 
discussion from someone saying that didn't fix the problem for them, 
which I wasn't CCed on.. It looks like in their case, libata is 
receiving SGs with DMA addresses above 4GB even though the block layer 
bounce limit is set to 32-bit. That's the mechanism that sata_nv depends 
on to ensure that it gets proper addresses when accessing ATAPI devices 
where it is limited to 32-bit DMA.. Could that be breaking or 
insufficient somehow?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

