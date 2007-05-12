Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbXELScp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbXELScp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXELScj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:32:39 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:8161 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbXELSci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:32:38 -0400
Date: Sat, 12 May 2007 12:32:13 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] "volatile considered harmful" document
In-reply-to: <fa.fKNBJtZJWOQthlLjc1TDfY6jCLc@ifi.uio.no>
To: Bill Davidsen <davidsen@tmr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Message-id: <4646082D.2080502@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.UIDGHS72acFv9jKylmdQQwWcXPA@ifi.uio.no>
 <fa.fKNBJtZJWOQthlLjc1TDfY6jCLc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Jonathan Corbet wrote:
> 
>> +There are still a few rare situations where volatile makes sense in the
>> +kernel:
>> +
>> +  - The above-mentioned accessor functions might use volatile on
>> +    architectures where direct I/O memory access does work.  
>> Essentially,
>> +    each accessor call becomes a little critical section on its own and
>> +    ensures that the access happens as expected by the programmer.
>> +
>> +  - Inline assembly code which changes memory, but which has no other
>> +    visible side effects, risks being deleted by GCC.  Adding the 
>> volatile
>> +    keyword to asm statements will prevent this removal.
>> +
>> +  - The jiffies variable is special in that it can have a different 
>> value
>> +    every time it is referenced, but it can be read without any special
>> +    locking.  So jiffies can be volatile, but the addition of other
>> +    variables of this type is frowned upon.  Jiffies is considered to 
>> be a
>> +    "stupid legacy" issue in this regard.
> 
> It would seem that any variable which is (a) subject to change by other 
> threads or hardware, and (b) the value of which is going to be used 
> without writing the variable, would be a valid use for volatile.

You don't need volatile in that case, rmb() can be used.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

