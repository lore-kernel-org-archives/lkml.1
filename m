Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbXFVPh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbXFVPh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbXFVPhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:37:51 -0400
Received: from homer.mvista.com ([63.81.120.155]:9141 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756726AbXFVPhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:37:50 -0400
Message-ID: <467BED34.4080004@ru.mvista.com>
Date: Fri, 22 Jun 2007 19:39:32 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
References: <20070618175713.GD5836@austin.ibm.com>
In-Reply-To: <20070618175713.GD5836@austin.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas wrote:

> I've got a hard lockup in the ide subsystem, probably
> due to some irq spew or something like that.

> I've just bought a brand new Maxtor 320GB disk driver 
> for the insane price of $70 US to replace another 
> failing drive. It works well under light load;
> I was able to copy about 60GB to it. However, 
> under heavy load, such as reconstruction of an MD 
> RAID-1 array, it'll lock up the kernel.  Which means
> that my system won't boot :-(

> I'm running 2.6.21.1, although the problem seems to occur 
> in 2.6.19 and 2.6.18 too; its been there a while; I vageuly
> remember similar problems in 2.6.5 or 2.6.10.

    Ah... so you're saying that the old disk works OK, yet you've already 
observed alike behavior on other disks... That speaks against blacklisting the 
drive.

> I can get the system to boot by sneaking in an 
> "hdparm -d0 /dev/hdc" early in the boot process, to turn off 

    Could probably do the same trick and specify the lower DMA speed by using 
-X n option (where n ranges from 64 to 70 for UltraDMA modes 0 to 6) and see 
if it changes anything...

> the use of DMA, but it seems that PIO is so slow, that it takes 
> forever to get NFS started.

    You can use 'ide=nodma' kernel option for this.

MBR, Sergei
