Return-Path: <linux-kernel-owner+w=401wt.eu-S1761933AbZDQQPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761933AbZDQQPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760399AbZDQQPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:15:22 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:41219 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761862AbZDQQPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:15:21 -0400
Message-ID: <49E8AB11.4000708@nortel.com>
Date: Fri, 17 Apr 2009 10:15:13 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: how to tell if arbitrary kernel memory address is backed by physical
 memory?
References: <49E750CA.4060300@nortel.com> <alpine.DEB.1.10.0904161654480.7855@qirst.com>
In-Reply-To: <alpine.DEB.1.10.0904161654480.7855@qirst.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2009 16:15:16.0689 (UTC) FILETIME=[B21AE410:01C9BF77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 16 Apr 2009, Chris Friesen wrote:

>> Is there a portable way to tell whether a particular virtual address in the
>> lowmem address range is backed by physical memory and is readable?
>>
>> For background...we have some guys working on a software memory scrubber for
>> an embedded board.  The memory controller supports ECC but doesn't support
>> scrubbing  in hardware.  What we want to do is walk all of lowmem, reading in
>> memory.  If a fault is encountered, it will be handled by other code.
> 
> Virtual address in the lowmem address range? lowmem address ranges exist
> for physical addresses.
> 
> If you walk lowmem (physical) then you will never see a missing page.

We have a mips board that appears to have holes in the lowmem mappings 
such that blindly walking all of it causes problems.  I assume the 
allocator knows about these holes and simply doesn't assign memory at 
those addresses.

We may have found a solution though...it looks like virt_addr_valid() 
returns false for the problematic addresses.  Would it be reasonable to 
call this once for each page before trying to access it?

Chris

