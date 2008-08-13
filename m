Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYHMPSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYHMPSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYHMPSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:18:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42299 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbYHMPSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:18:41 -0400
Date: Wed, 13 Aug 2008 17:18:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Bruce Duncan <bwduncan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] ftrace for v2.6.27
Message-ID: <20080813151827.GA10819@elte.hu>
References: <20080714142226.GA11412@elte.hu> <200808130248.58216.bwduncan@gmail.com> <48A2F9AB.8000608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A2F9AB.8000608@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <srostedt@redhat.com> wrote:

> Bruce Duncan wrote:
>> Hi Ingo, Steven, everyone,
>>
>> [ Please CC me in replies ]
>>
>> I have just tracked down a regression in 2.6.27-rc2 wrt 2.6.26. Commit  
>> 77a2b37d227483fe52aead242652aee406c25bf0 (ftrace: startup tester on 
>> dynamic tracing.) causes my laptop to fail to resume from S3 (it simply 
>> reboots about a second after the resume starts and the display never 
>> shows anything).
>>
>> The patch doesn't revert with patch -R (I don't know if there's a 
>> cleverer way to ask git to revert it), but the problem goes away if I 
>> turn off CONFIG_DYNAMIC_FTRACE.
>>
>> The commit and bisect log are attached. Please can you help me to debug this?
>>
>>
>>   
>
> I found that I have a box that displays this bug. Without FTRACE it 
> suspends and resumes fine. With FTRACE enabled, it does not.
>
> I'll be actively debugging it now. (unfortunately, as with all new 
> laptops, I don't have a serial for it).

try latest tip/master plus an USB debug key, then enable 
CONFIG_EARLY_PRINTK_DBGP=y in your .config on the host, add the 
earlyprintk=dbgp,keep boot parameter and reboot [and disable USB for 
good measure]. On the other host you connect to via an USB cable, enable 
USB_SERIAL_DEBUG=y and use /dev/ttyUSB0 with the serial terminal app of 
your choice.

that, as long as the USB ports are operational, gives a working serial 
console on just about any laptop.

	Ingo
