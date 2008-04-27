Return-Path: <linux-kernel-owner+w=401wt.eu-S1764778AbYD0XC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778AbYD0XC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYD0XCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:02:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47863 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbYD0XCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:02:18 -0400
Message-ID: <481505ED.4050008@garzik.org>
Date: Sun, 27 Apr 2008 19:02:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <20080427214837.GA11631@elte.hu>	<1209335660.3801.79.camel@localhost.localdomain>	<4815009C.2010809@garzik.org> <20080427.154620.177583216.davem@davemloft.net> <481503ED.8060107@garzik.org> <481504BA.4090402@zytor.com>
In-Reply-To: <481504BA.4090402@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeff Garzik wrote:
>>
>> Understood.
>>
>> I guess I am more annoyed that this stealth semantics change appears 
>> to have broken everything that depends on pci_iomap(), including 90%+ 
>> of all libata drivers, unless I am missing something.
>>
>> That one piece of code (pci_iomap) was correct under the old 
>> semantics, on x86 and elsewhere.  It's tested and working nicely, and 
>> depended upon by many drivers.
>>
> 
> That one piece of code has had no effective change.  Under both the old 
> and the new code, both branches functionally because ioremap_nocache(), 
> in one case because of MTRR and in one case because of PAT.

OK good...  libata uses it for controller registers exclusively, so that 
should be fine from an operational standpoint.

The lack of discussion is still a bit irksome...  at the very least I 
could have pointed out that lib/iomap.c wanted an update, and the 2.5 yo 
discussion could have resurfaced.

	Jeff



