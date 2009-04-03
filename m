Return-Path: <linux-kernel-owner+w=401wt.eu-S1763233AbZDCVs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763233AbZDCVs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935086AbZDCVsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:48:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33902 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762578AbZDCVso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:48:44 -0400
Message-ID: <49D68431.30703@garzik.org>
Date: Fri, 03 Apr 2009 17:48:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <1238758370.32764.5.camel@think.oraclecorp.com> <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain> <49D66C0E.5090301@garzik.org> <alpine.LFD.2.00.0904031309500.4015@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904031309500.4015@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.2 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.2 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 3 Apr 2009, Jeff Garzik wrote:
>> Yeah, it's a no-name SSD.
>>
>> I've attached 'hdparm -I' in case anyone is curious.  It's from newegg.com, so
>> nothing NDA'd or sekrit.
> 
> Hmm. Does it do ok on the "random write" test? There's a few non-intel 
> controllers that are fine - apparently the newer samsung ones, and the one 
> from Indilinx.
> 
> But I _think_ G.SKILL uses those horribly broken JMicron controllers. 
> Judging by your performance numbers, it's the slightly fancier double 
> controller version (ie basically an internal RAID0 of two identical 
> JMicron controllers, each handling half of the flash chips).

Quoting from the review at
http://www.bit-tech.net/hardware/storage/2008/12/03/g-skill-patriot-and-intel-ssd-test/2

"Cracking the drive open reveals the PCB fitted with sixteen Samsung 
840, 8GB MLC NAND flash memory modules, linked to a J-Micron JMF 602 
storage controller chip."


> Try a random write test. If it's the JMicron controllers, performance will 
> plummet to a few tens of kilobytes per second.

Since I am hacking on osdblk currently, I was too slack to code up a 
test.  This is what bonnie++ says, at least...

> Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> bd.yyz.us     8000M           28678   6 27836   5           133246  12  5237  10
>                     ------Sequential Create------ --------Random Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
>               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
>                  16 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++
> bd.yyz.us,8000M,,,28678,6,27836,5,,,133246,12,5236.6,10,16,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++,+++++,+++

But I guess seeks are not very helpful on an SSD :)  Any pre-built 
random write tests out there?

Regards,

	Jeff



