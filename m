Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXBQSPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXBQSPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030238AbXBQSPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:15:36 -0500
Received: from noname.neutralserver.com ([70.84.186.210]:27823 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030237AbXBQSPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:15:35 -0500
Message-ID: <45D7462D.6080700@monatomic.org>
Date: Sat, 17 Feb 2007 20:15:09 +0200
From: Dan Aloni <da-x@monatomic.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       linux-usb-devel-bounces@lists.sourceforge.net
Subject: Re: [linux-usb-devel] OOM and USB, latest Linux 2.6
References: <Pine.LNX.4.44L0.0702171156300.4173-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0702171156300.4173-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PopBeforeSMTPSenders: da-x@monatomic.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sat, 17 Feb 2007, Dan Aloni wrote:
>
>   
>> Hello,
>>
>> Is it possible that OOM isn't handled very well if say, my entire
>> file system structure is on a USB storage device?
>>
>> I'm not an expert on this particular matter but I'm pretty sure 
>> that I noticed GFP_KERNEL allocation being done on the write-out 
>> path in the usb-storage kernel thread, leading to a deadlock 
>> during OOM.
>>     
>
> Can you be any more specific than that?  usb-storage should use only 
> GFP_NOIO in its I/O paths.
>
>
>   
You are right, I looked over this state with kdb, and usb-storage
waited in usb_stor_bulk_transfer_sg, which does pass GFP_NOIO
at this scenario.

It looked suspicious though, because OOM handling was invoked
from many processes, and it didn't print about any process being
killed and it didn't complain about no processes to kill either.

(I'll look more into this, perhaps there's an OOM handling bug)

BTW, soft-rebooting the machine in that state made the USB
storage device (LEXAR,  JD LIGHTNING II) inaccessible to the
BIOS. I had to do a complete power cycle in order or the BIOS
to see it again.

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il

