Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbYLXVQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbYLXVQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 16:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYLXVQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 16:16:01 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:35305 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbYLXVQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 16:16:00 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=fZOW-UbsGydyh5iGM48A:9 a=tEbYFxX8i4CJ0KYZNnSPxzdPSisA:4
Message-ID: <4952A68E.2030906@shaw.ca>
Date: Wed, 24 Dec 2008 15:15:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: Memory vs. MMIO ordering, again
References: <gittnv$2qj$1@ger.gmane.org> <20081224183238.3253d7b9@lxorguk.ukuu.org.uk>
In-Reply-To: <20081224183238.3253d7b9@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> MMIO accesses may, in effect, overtake accesses to cached memory that 
>> were emitted earlier. A memory barrier isn't sufficient in such a case, 
>> but rather the cache must be flushed between the cached memory write and 
>> the MMIO access if the two are in any way dependent."
>>
>> This seems like BS to me.. Flush the cache? How is a driver supposed to 
>> know how to do that? Furthermore, why should it need to worry about this 
>>   kind of detail? This seems wrong or at least a low-level detail that 
>> normal code should not have to be concerned with.
> 
> There isn't really much choice in the matter. However if you are using
> the normal pci_map_ and pci_alloc_coherent functions then those have your
> cache management built into them and all you have to watch is compiler
> funnies.

What that documentation is suggesting is that MMIO writes to uncached 
memory (what the normal mapping functions will give you) can pass 
previous writes to cached memory. It doesn't indicate how this is to be 
avoided, however.

The arch that was being discussed in that 2006 discussion was PPC, but 
it appears that it's been changed to ensure that writeX, etc. will 
provide the expected ordering (commit 
f007cacffc8870702a1473d83ba5e4922d54e17c). I'm not sure what 
architecture the author of those paragraphs in 
Documentation/memory-barriers.txt had in mind, though. CCing David 
Howells as he apparently wrote them..
