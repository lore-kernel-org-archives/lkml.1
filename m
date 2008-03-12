Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYCLU4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYCLU4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYCLU4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:56:30 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:8386 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYCLU43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:56:29 -0400
Message-ID: <47D8436F.9080901@codemonkey.ws>
Date: Wed, 12 Mar 2008 15:56:15 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: akpm@osdl.org, linux-s390@vger.kernel.org, frankeh@watson.ibm.com,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, schwidefsky@de.ibm.com, hugh@veritas.com
Subject: Re: [patch 6/6] Guest page hinting: s390 support.
References: <20080312132132.520833247@de.ibm.com>		<20080312132704.474209626@de.ibm.com> <47D802A2.1030406@goop.org>		<1205339285.8851.13.camel@localhost> <47D8085E.9030701@goop.org>	<1205341164.8851.44.camel@localhost> <47D81771.5070400@goop.org> <47D8373C.40105@codemonkey.ws> <47D840E3.5090902@goop.org>
In-Reply-To: <47D840E3.5090902@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> Well presumably Vp/Pr => Sp?  Is is true that from the guest's 
>> perspective, all of the 'p' states are identical to the 'r' states?
>>   
>
> Vp should never happen, since you'd never preserve a V page.  And 
> surely it would be Pr -> Sr, since the hypervisor wouldn't push the 
> page to backing store when you change the client state.

You're right, I meant Vp/Pp but they are invalid states.  I think one of 
the things that keeps tripping me up is that the host can change both 
the host and guest page states.  My initial impression was that the host 
handled the host state and the guest handled the guest state.

>> Do the host states even really need visibility to the guest at all?  
>> It may be useful for the guest to be able to distinguish between Ur 
>> and Uz but it doesn't seem necessary.
>
> Well, you implicitly see the hypervisor state.  If you touch a [UV]z 
> page then you get a fault telling you that the page has been taken 
> away from you (I think).  And it would definitely help with debugging 
> (seems likely there's lots of scope for race conditions if you 
> prematurely tell the hypervisor you don't need the page any more...).

I was thinking that it may be useful to know a Ur verses a Uz when 
allocating memory.  In this case, you'd rather allocate Ur pages verses 
Uz to avoid the fault.  I don't read s390 arch code well, is the host 
state explicit to the guest?

>> BTW Jeremy, the .dot was very useful!
> Yes, there's no way I'd be able to get my head around this otherwise.  
> BTW, here's an updated one with the host-driven events as dashed 
> lines, and a couple of extra transitions I think should be in there 
> (but waiting for Martin's confirmation).

Excellent!

Regards,

Anthony LIguori

>    J

