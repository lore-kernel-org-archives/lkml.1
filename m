Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZF3TAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZF3TAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZF3S7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 14:59:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZF3S7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 14:59:51 -0400
Message-ID: <4A4A5EF1.3080005@zytor.com>
Date: Tue, 30 Jun 2009 11:52:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
CC: Mikael Pettersson <mikpe@it.uu.se>, Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19017.53428.834539.389495@pilspetsen.it.uu.se> <4A4A25B1.5010102@zytor.com> <200906301700.55536.eike-kernel@sf-tec.de>
In-Reply-To: <200906301700.55536.eike-kernel@sf-tec.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rolf Eike Beer wrote:
> H. Peter Anvin wrote:
>> Mikael Pettersson wrote:
>>> Thanks, 2.6.31-rc1 vanilla (which didn't boot) plus this one does boot.
>>> /proc/iomem now looks as follows:
>> ... as it should.  So far so good, and this is a real problem.
>>
>> However, there is something that really bothers me: *why does this help
>> on Mikael's system, which is PAE and therefore has a 64-bit
>> resource_size_t*?  This whole patch should be a no-op!  There is still
>> something that doesn't make sense.
>>
>> The use of "unsigned long" in ram_alignment() will overflow after 2^52
>> bytes, but again, that's not the issue here, since the highest "start"
>> value we have is (0x2 << 32).
> 
> I assume you meant "2^32" and (0x1 << 32)?
> 

No, I meant 2^52 and (0x2 << 32) [== 2^33.]

	-hpa

