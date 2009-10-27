Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbZJ0SSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbZJ0SSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756575AbZJ0SSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:18:23 -0400
Received: from claw.goop.org ([74.207.240.146]:38858 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574AbZJ0SSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:18:23 -0400
Message-ID: <4AE73973.3070709@goop.org>
Date: Tue, 27 Oct 2009 11:18:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Christian Kujau <lists@nerdbynature.de>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.32-rc not booting with Xen-3.2 (bisected)
References: <alpine.DEB.2.01.0910261445170.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261513520.9408@bogon.housecafe.de> <4AE628DB.5010305@goop.org> <alpine.DEB.2.01.0910261759470.9408@bogon.housecafe.de> <alpine.DEB.2.01.0910261820050.9408@bogon.housecafe.de> <4AE67506.2040200@goop.org> <alpine.DEB.2.01.0910262154410.9408@bogon.housecafe.de>
In-Reply-To: <alpine.DEB.2.01.0910262154410.9408@bogon.housecafe.de>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/09 22:01, Christian Kujau wrote:
> On Mon, 26 Oct 2009 at 21:20, Jeremy Fitzhardinge wrote:
>   
>> What does this map to in the kernel symbol table?
>>     
> Hm, I'm not sure how to answer this? Got a hint, please?
>   

$ gdb vmlinux
(gdb) x/i 0xffffffff812c50ad

>>> Also, "xm list" takes very long to complete now:
>>>
>>> $ time xm list sid
>>> Name                  ID   Mem VCPUs      State   Time(s)
>>> sid                  906   512     1     --p---     0.0
>>> real    0m10.677s user    0m0.108s sys     0m0.028s
>>>       
>> Hm, that's odd.  Never seen that.
>>     
> The load of the Dom0 with the panicked DomU "running" higher than 
> usual (3-4 instead of ~0) and xenstored is spinning and waiting for 
> (causing?) disk I/O. This is not the case when the DomU is runing just 
> fine. I didn't strace xenstored yet, because I don't want to risk
> killing the whole Xen box.
>   

Hm, sounds like a xenstored bug, or something is just pounding on it. 
Are there any other domains running, or other busy processes?

    J
