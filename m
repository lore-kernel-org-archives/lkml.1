Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbXLWEN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbXLWEN6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 23:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbXLWENv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 23:13:51 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51375 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbXLWENu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 23:13:50 -0500
Message-ID: <476DE07A.4000204@garzik.org>
Date: Sat, 22 Dec 2007 23:13:46 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sat, 22 Dec 2007, Jeff Garzik wrote:
>> Regardless of whether a driver is loaded or not, you may NEED to see extended
>> capabilities.  The system may NEED to see those capabilities just to parse
>> them for sane operation.
> 
> And that's just not true.
> 
> I don't know why you even claim so. There is absolutely *zero* need for 
> MMCONFIG for 100% of old hardware, and old hardware is exactly the 
> problem. The hardware that people will run next year isn't the issue.

I'm not claiming anything about old hardware.

It should be self-evident that mmconfig doesn't work on old hardware, is 
not needed on old hardware, should not be turned on for old hardware, 
and in general should never disturb old hardware.


> There may be an absolute need for MMCONFIG for future machines and future 
> drivers, but there is not a single machine in existence today that really 
> depends on it. You're just making things up. At worst, you lose some 
> not-so-important error reporting, no more.
> 
> So don't go spreading obvious untruths,


The facts as they exist today:

1) Existing 256-byte config space devices have been known put 
capabilities in the high end (>= 0xc8) of config space.

2) It is legal for PCI-Express to put capabilities anywhere in PCI 
config space, including extended config space.  (I hope our PCI cap 
walking code checks for overruns...)

3) Most new machines ship with PCI-Express devices with extended config 
space.

Therefore it is provable /possible/, and is indeed logical to conclude 
that capabilities in extended config space will follow the same pattern 
that existing hw designers have been following...  but only once the 
current OS's have stable extended-config-space support.

Maybe that day will never come, but it is nonetheless quite possible 
without today's PCI Express spec for this to happen.

We must handle this case, even if mmconfig is COMPLETELY DISABLED (i.e. 
normal mode today).

	Jeff



