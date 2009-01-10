Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZAJPKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZAJPKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZAJPKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:10:06 -0500
Received: from h155.mvista.com ([63.81.120.155]:64615 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751589AbZAJPKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:10:05 -0500
Message-ID: <4968BA6F.8050207@ru.mvista.com>
Date: Sat, 10 Jan 2009 18:10:39 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
 ata_sff_hsm_move+0x45e/0x750()
References: <200901091334.55823.borntraeger@de.ibm.com>	<200901101009.13699.borntraeger@de.ibm.com>	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>	<200901101242.05203.borntraeger@de.ibm.com>	<49688B63.5030105@ru.mvista.com>	<20090110122130.318cf168@lxorguk.ukuu.org.uk>	<20090110130745.GA14049@elte.hu>	<49689EA8.20506@garzik.org>	<20090110132412.GB14049@elte.hu>	<20090110133617.GA22304@elte.hu> <20090110135731.0da08c90@lxorguk.ukuu.org.uk>
In-Reply-To: <20090110135731.0da08c90@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>* Ingo Molnar <mingo@elte.hu> wrote:

>>>build its random kernel and reboot into it (800 MHz P3), so i started a 
>>>full automated bisection instead driven from a faster box.

>>and the winner is:
>>| 871af1210f13966ab911ed2166e4ab2ce775b99d is first bad commit
>>| commit 871af1210f13966ab911ed2166e4ab2ce775b99d
>>| Author: Alan Cox <alan@redhat.com>
>>| Date:   Mon Jan 5 14:16:39 2009 +0000
>>|
>>|     libata: Add 32bit PIO support
>>
>>And the revert below does the trick.

> Unfortunately it only hides the bug - that code doesn't change the sg
> lists being passed, it just catches out anyone who pasts a non divisble
> by four malformed sg list.

    All the S/G counts printed out were divisible by 4 (36 for INQUIRY and 96 
for REQUSET SENSE). It's the *actual* byte count for the REQUEST SENSE that's 
no divisible. The SCSI/ATAPI devices are free to sent less data than requested 
on non block transfer commands.

MBR, Sergei
