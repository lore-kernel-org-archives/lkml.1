Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab0BDIyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:54:15 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:14163 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab0BDIyK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;8:2>);
	Thu, 4 Feb 2010 03:54:10 -0500
Message-Id: <4B6A9960020000780002DA6B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 04 Feb 2010 08:54:40 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Dan Carpenter" <error27@gmail.com>,
       <bernhard.kaindl@gmx.net>, "Thomas Gleixner" <tglx@linutronix.de>,
       <linux1394-devel@lists.sourceforge.net>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Rafael Wysocki" <rjw@sisk.pl>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <ebiderman@xmission.com>, <hpa@zytor.com>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug
	 #14487] PANIC: early exception 08 rip 246:10 error
	 ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
 <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com>
 <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com>
 <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com>
 <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com>
 <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com>
 <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de>
 <4B68D4CA.2010803@gmail.com> <4B694D5C020000780002D6DA@vpn.id2.novell.com>
 <4B6A0123.3010607@gmail.com>
In-Reply-To: <4B6A0123.3010607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Justin P. Mattock" <justinmattock@gmail.com> 04.02.10 00:05 >>>
>[   0.000000] 0100000000 - 0140000000 page 2M
>[   0.000000] kernel direct mapping tables up to 140000000 @ b000-11000
>[   0.000000] init_ohci1394_dma: initializing OHCI-1394 at 05:00.0
>[   0.000000] bootmem alloc of 4096 bytes failed!
>[   0.000000] Kernel panic - not syncing: Out of memory
>[   0.000000] Pid: 0, comm: swapper Not tainted 
>2.6.33-rc6-00072-gab65832 # 39
>[   0.000000] Call Trace:
>
>then the rest shown on the picture on the bug report.
>
>Out of memory?

bootmem allocation before bootmem was even initialized. And that's
likely because the code tries to populate the pmd that (due to the
issue explained yesterday) isn't statically initialized.

Jan

