Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYCMIwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYCMIwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 04:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYCMIwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 04:52:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51408 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYCMIwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 04:52:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47D8EA7F.8040703@s5r6.in-berlin.de>
Date: Thu, 13 Mar 2008 09:49:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: sync AT dma buffer before use
References: <200803121743.29438.jwilson@redhat.com> <47D8645B.5040305@s5r6.in-berlin.de> <200803122111.55754.jwilson@redhat.com>
In-Reply-To: <200803122111.55754.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> On Wednesday 12 March 2008 07:16:43 pm Stefan Richter wrote:
>> Jarod Wilson wrote:
>>> See http://bugzilla.kernel.org/show_bug.cgi?id=9617
>> Alas the panic from comment #10 is still there, i.e. instant crash when
>> plugging in an LSI based CD-RW (shortly after SCSI inquiry) --- but only
>> if CONFIG_DEBUG_PAGEALLOC=y.
>>
>> Jarod, did your crashes happen with CONFIG_DEBUG_PAGEALLOC=n?
> 
> No, they're with it turned on (and still on w/this change where it doesn't 
> panic). If I run with CONFIG_DEBUG_PAGEALLOC=n, no panic.

So then that's like "my" panic.

The other thing that I see here is that it only happens with my two LSI 
based devices (both CD-RWs), always quickly after SCSI inquiry.

I shall test with my Prolific based DVD-RW to find out whether it is 
about some requests that are sent to CD/DVD-RWs or about the split 
transactions that I get from the LSI bridges.  (See bugzilla.)

>> So this patch shouldn't do 
>> anything, except that it inserts a call which happens to have barrier
>> characteristics on some platforms.

...and potentially delays execution.

> ...but got lucky in that it actually helps this particular setup (x86_64 
> kernel, dual quad-core opteron, 8G RAM, 3 FireWire controllers). Hrm.

Unless you or I spot the real solution earlier, you could also try 
replacing your dma_sync_ with mb() and with mdelay() respectively to see 
what aspect of the dma_sync_ is fixing your setup.  Also move the mb() 
to other interesting places of the involved code.
-- 
Stefan Richter
-=====-==--- --== -==-=
http://arcgraph.de/sr/
