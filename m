Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZF3CHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZF3CHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbZF3CGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:06:48 -0400
Received: from fmailhost04.isp.att.net ([204.127.217.104]:57803 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676AbZF3CGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:06:47 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A49733D.9030602@lwfinger.net>
Date: Mon, 29 Jun 2009 21:06:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net> <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Mon, 29 Jun 2009, Larry Finger wrote:
> 
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13319
>>> Subject		: Page allocation failures with b43 and p54usb
>>> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
>>> Date		: 2009-04-29 21:01 (61 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=124103897101088&w=4
>>> 		  http://lkml.org/lkml/2009/6/7/136
>>> Handled-By	: Johannes Berg <johannes@sipsolutions.net>
>> The cause of these failures has been determined. The wireless
>> subsystem frequently requests buffers of size 4096, but when SLUB
>> debugging is enabled and the debug info is added, the request becomes
>> of order 1 and memory becomes fragmented.
>>
>> A controversial "fix" in which SLUB debugging was disabled for
>> allocations where adding such debugging info would increase the order
>> was discussed and tried. With a quick look at the commit list for
>> Linus's tree, I don't see that such a patch is available, but I will
>> be corrected if I missed it.
>>
> 
> I'd disagree with disabling slub debugging by default for caches where 
> oo_order(s->min) increases as the result of using it.  This particular 
> page allocation failure is happening for, presumably, kmalloc-4096, and 
> the system has 4K pages.  Disabling debugging for that cache (and any of 
> its aliases) implicitly will lead to errors going undiagnosed as a result.

If the current behavior is not changed, I will be forced to disable
SLUB debugging, which will explicitly lead to errors that are
undiagnosed. It seems better to me to debug when you can, but turn off
debugging in cases like this.

Larry

