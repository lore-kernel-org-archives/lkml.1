Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbXH3BeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbXH3BeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 21:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbXH3BeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 21:34:12 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:43021 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbXH3BeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 21:34:11 -0400
Date: Wed, 29 Aug 2007 19:33:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Bugme-new] [Bug 8957] New: Exported functions and variables
 should not be reachable by the outside of the module until module_init finishes
In-reply-to: <fa.+esfGGdgETnuZiuGXcL9U8IpoNM@ifi.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, mattilinnanvuori@yahoo.com
Message-id: <46D61E7C.20304@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.fGbKfAxvHbZD1OUm5bpknraMlkQ@ifi.uio.no>
 <fa.+esfGGdgETnuZiuGXcL9U8IpoNM@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 29 Aug 2007 11:33:06 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
>> http://bugzilla.kernel.org/show_bug.cgi?id=8957
>>
>>            Summary: Exported functions and variables should not be reachable
>>                     by the outside of the module until module_init finishes
>>            Product: Other
>>            Version: 2.5
>>      KernelVersion: 2.6.23-rc4
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: Modules
>>         AssignedTo: other_modules@kernel-bugs.osdl.org
>>         ReportedBy: mattilinnanvuori@yahoo.com
>>
>>
>> Problem Description: a module's exported functions can be called before before
>> they are properly initialized by the module_init function.
>>
>> Steps to reproduce: write a module that exports functions that require
>> initialization by the module_init function to work correctly.
>>
>> E.g. spin lock variables are no longer allowed to be initialized by C
>> initializers of the module but only by spin_lock_init that can be called by the
>> module_init function. If an exported function calls spin_lock before it is
>> initialized, it deadlocks.
>>
> 
> ooh, nice bug ;)

Under what circumstances is this actually happening? What are these 
functions that are being called?

Normally things are set up such that this isn't a problem, i.e. if 
module A depends on module B, module A can't load until module B is 
finished loading.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

