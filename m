Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXDZWgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXDZWgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbXDZWgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:36:51 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:51559 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753253AbXDZWgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:36:50 -0400
Message-ID: <46312787.1020702@aitel.hist.no>
Date: Fri, 27 Apr 2007 00:28:23 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang - bisection result
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704122023510.12991@twin.jikos.cz> <20070412202519.GB14705@aitel.hist.no> <Pine.LNX.4.64.0704130107170.12991@twin.jikos.cz> <462F2558.5010909@aitel.hist.no> <Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0704251324540.20657@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 25 Apr 2007, Helge Hafting wrote:
>   
>>
>> I don't know about 2.6.21-rc6, but 2.6.21-rc7 (from fresh sources) is 
>> good.  It boots up without hanging, and my USB devices works too. Should 
>> I test rc7-mm1 then?
>>     
>
> That would also be useful.
>
> But really identifying offending patch using bisection would help most. 
> And it should be pretty easy and not too much time consuming for you, as 
> the bug triggers immediately upon boot in your case.
>   
2.6.21-rc6 boots up fine.  Both rc6 and rc7 has a different problem - the
machine tends to hang after some minutes work in X.  That hang is
unusual in that moving the mouse still move the X cursor, but
everything else stops and sysrq fails me. But that is another story.

rc6 boots, rc6-mm1 hangs at the "usbcore registered hiddev" message.
Bisection:
1, 2, 3: the three first hangs at "usbcore registered hiddev"
4, 5, 6: the next three hangs at a message about ACPI  PCI[A]->IRQ17
I decided to keep bisecting these hangers as "bad", I don't really know
if this could be the same thing or completely different issues.  If they are
different, then one problem will mask the other anyway, so
calling every hanging kernel "bad" will at least find the first broken 
patch.
7: boots up ok!
8,9,10: hangs at the aboce mentioned ACPI message
The (first) "hanging" patch in 2.6.21-rc6-mm1 is: git-acpi.patch

Helge Hafting








