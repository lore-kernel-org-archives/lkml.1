Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbYBEQee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbYBEQee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYBEQeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:34:24 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:22673 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYBEQeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:34:23 -0500
Message-ID: <47A88FDF.6090102@hp.com>
Date: Tue, 05 Feb 2008 11:33:35 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-driver@qlogic.com, Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: 2.6.24 regression w/ QLA2300
References: <47A88736.6090706@hp.com> <20080205160246.GF19882@plap3.qlogic.org> <20080205161501.GG19882@plap3.qlogic.org>
In-Reply-To: <20080205161501.GG19882@plap3.qlogic.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Vasquez wrote:
> On Tue, 05 Feb 2008, Andrew Vasquez wrote:
> 
>> On Tue, 05 Feb 2008, Alan D. Brunelle wrote:
>>
>>> commit 9b73e76f3cf63379dcf45fcd4f112f5812418d0a
>>> Merge: 50d9a12... 23c3e29...
>>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>>> Date:   Fri Jan 25 17:19:08 2008 -0800
>>>
>>>     Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
>>>
>>>     * git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6: (200 commits)
>>>
>>> I believe a regression was introduced. I'm running on a 4-way IA64,
>>> with straight 2.6.24 and 2 dual-port cards:
>>>
>>> 40:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
>>> 40:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
>>> c0:01.0 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
>>> c0:01.1 Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter (rev 03)
>>>
>>> the adapters failed initialization. In particular, I narrowed it down
>>> to failing the qla2x00_mbox_command call within qla2x00_init_firmware
>>> function. I went and removed the qla2x00-related parts of this (large-ish)
>>> merge, and the 4 ports initialized just fine.
>> Could you load the (default 2.6.24) driver with
>> ql2xextended_error_logging modules parameter set:
>>
>> 	# insmod qla2xxx ql2xextended_error_logging=1
>>
>> and send the resultant kernel logs?
> 
> Could you tray the patch referenced here:
> 
> qla2xxx: Correct issue where incorrect init-fw mailbox command was used on non-NPIV capable ISPs.
> http://article.gmane.org/gmane.linux.scsi/38240
> 
> Thanks, av

The referenced patch worked fine Andrew, thanks much! 

Alan
