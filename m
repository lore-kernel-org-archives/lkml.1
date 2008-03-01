Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYCAPpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYCAPpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 10:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYCAPpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 10:45:12 -0500
Received: from mail.syneticon.net ([213.239.212.131]:45199 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbYCAPpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 10:45:11 -0500
Message-ID: <47C979EF.7070906@wpkg.org>
Date: Sat, 01 Mar 2008 16:44:47 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, agk@redhat.com,
       herbert@gondor.apana.org.au, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [dm-devel] Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ritesh Raj Sarraf wrote:

(...)

> Meanwhile I was able to reproduce the bug again with the same configuration 
> and the same scenario. So I believe that the bug can be reproduced 
> consistently.
> 
> Here are the steps:
> 
> 1) Initialize a device using dm-crypt and LUKS
> 2) Create a filesystem on top of it and mount it.
> 3) Write huge amount of data (as a normal user). Something like 150GB.
> 
> As the load goes hight (to something like 12-14), the kernel lock-up is logged 
> into dmesg.
> At that moment, the OS is barely responsive.

I tried to reproduce it on two machines running 2.6.24.2, with cfq 
scheduler.

One machine, with 5x HDD, RAID-5, dm-crypt/LUKS, LVM, ext3 on top of it 
all - I created a 250 GB file, the load was 4-5. No lockups or anything.
Later, removing that 250 GB file took over 7 minutes, but that's a 
different story.


Second machine, dm-crypt on a USB-connected drive, LVM, ext3 on top of 
it, X with nvidia binary blob (version 169.09). I created a 190 GB file, 
the load was indeed pretty high - up to about 14. But still, no lockups 
of any kind.


-- 
Tomasz Chmielewski
http://wpkg.org
