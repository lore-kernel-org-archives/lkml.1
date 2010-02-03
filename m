Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab0BCXDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:03:42 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:55012 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab0BCXDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fS5x/QCZQB7Gqrx05+wiaIg107i5SW5QkIyWsyjHj7Dl1Lo34tnEmmy7236bT9sUgy
         TG6xVYbqd+X0OaG/UEUPGbc5S8r1joBg6F++tqZTMSwHCeHcAut0W+KctORJSsX0TDTO
         2WQKMR1QJvVMUXIzH3jS8zj1cd8r4Pebh02Ow=
Message-ID: <4B6A0123.3010607@gmail.com>
Date: Wed, 03 Feb 2010 15:05:07 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Dan Carpenter <error27@gmail.com>, bernhard.kaindl@gmx.net,
       Thomas Gleixner <tglx@linutronix.de>,
       linux1394-devel@lists.sourceforge.net, Rafael Wysocki <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebiderman@xmission.com, hpa@zytor.com
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug	 #14487]
 PANIC: early exception 08 rip 246:10	 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com> <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de> <4B68D4CA.2010803@gmail.com> <4B694D5C020000780002D6DA@vpn.id2.novell.com>
In-Reply-To: <4B694D5C020000780002D6DA@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. while looking into grub2
I had noticed during compile time
and reading posts, that -m32 is always
being called(no matter how much I tweaked the
Makefile). seeing this made me think well
if this thing is being built with -m32 maybe that might
be it i.g. 32bit to 64bit might cause some issues, but
unfortunately is not the case(building lilo you can achieve a pure64
bit build).

So after all of that still no go, but the positive side
is lilo is able to show more up the line of the boot message
error:

[   0.000000] 0100000000 - 0140000000 page 2M
[   0.000000] kernel direct mapping tables up to 140000000 @ b000-11000
[   0.000000] init_ohci1394_dma: initializing OHCI-1394 at 05:00.0
[   0.000000] bootmem alloc of 4096 bytes failed!
[   0.000000] Kernel panic - not syncing: Out of memory
[   0.000000] Pid: 0, comm: swapper Not tainted 
2.6.33-rc6-00072-gab65832 # 39
[   0.000000] Call Trace:

then the rest shown on the picture on the bug report.

Out of memory?

Justin P. Mattock
