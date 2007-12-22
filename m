Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbXLVUtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbXLVUtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbXLVUsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:48:54 -0500
Received: from main.gmane.org ([80.91.229.2]:34229 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbXLVUsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:48:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthew Bloch <matthew@bytemark.co.uk>
Subject: Re: Testing RAM from userspace / question about memmap= arguments
Date: Sat, 22 Dec 2007 20:48:20 +0000
Message-ID: <fkjt6r$rgt$1@ger.gmane.org>
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com> <20071222134612.GA4098@ucw.cz> <476D35F6.90900@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: desk.home.bloch.tv
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
In-Reply-To: <476D35F6.90900@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Pavel Machek wrote:
>> On Sat 2007-12-22 13:42:47, Richard D wrote:
>>  
>>> Cant you, modify bootmem allocator to test with memtest patterns and 
>>> then
>>> use kexec (as Pavel suggested) to test the one where kernel was sitting
>>> earlier?
>>>     
>>
>>
>> I do not think you need to modify anything in kernel. Just use
>> /dev/mem to test areas that kernel doesn't see, then kexec into place
>> you already tested, and test the rest.
>>   
> 
> That's still an insufficient test.  One failure mode is writes at one 
> location corrupting cells at another.
> 
> The idea of wanting to do comprehensive and robust memory testing from 
> within the operating system seems dubious at best, to me.  

Well if we're trying to be thorough, either way is flawed - you can't 
possibly test pathologically-misbehaving memory from code running from 
inside of it, you'd want some kind of non-uniform memory arrangement to 
do that properly.  memtest86's value is that it at least *tries* to work 
in this environment by dynamically relocating itself, but its memory 
testing algorithms aren't the hard bit.  Also I'm not necessarily 
interested in *which* section of which DIMM is faulty, just a yes or no 
is enough so I can send the faulty ones back to the shop.

I don't agree that adding a network stack to memtest86's bare kernel is 
going to be easier than working out how to get Linux to do the same job, 
with its luxurious programming environment.  I can already automate 
memtest via serial consoles, power cycling, network booting and so on 
but it's ugly.

I will report back in the new year when I've had a chance to play with 
our collection of dodgy hardware.

-- 
Matthew

