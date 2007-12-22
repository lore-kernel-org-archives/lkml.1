Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbXLVQGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbXLVQGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 11:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXLVQGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 11:06:25 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:39083 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbXLVQGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 11:06:24 -0500
Message-ID: <476D35F6.90900@davidnewall.com>
Date: Sun, 23 Dec 2007 02:36:14 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Richard D <richard@embunus.com>,
       "'Matthew Bloch'" <matthew@bytemark.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com> <20071222134612.GA4098@ucw.cz>
In-Reply-To: <20071222134612.GA4098@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2007-12-22 13:42:47, Richard D wrote:
>   
>> Cant you, modify bootmem allocator to test with memtest patterns and then
>> use kexec (as Pavel suggested) to test the one where kernel was sitting
>> earlier?
>>     
>
>
> I do not think you need to modify anything in kernel. Just use
> /dev/mem to test areas that kernel doesn't see, then kexec into place
> you already tested, and test the rest.
>   

That's still an insufficient test.  One failure mode is writes at one 
location corrupting cells at another.

The idea of wanting to do comprehensive and robust memory testing from 
within the operating system seems dubious at best, to me.  If there is 
something wrong with memtest86, doing the tests from within Linux is not 
the answer.  The answer is to fix memtest86.  If the problem is that you 
automation, e.g. switching a server from production to memory test mode 
at midnight and back again at 6am, the answer is still to "fix" 
memtest86.  Writing something that grabs some physical RAM from Linux's 
control, tests it, and then moves the kernel itself so that it can test 
the rest, is adding a whole extra layer of complexity to an already 
challenging (I assume, based on errors that dedicated software-based 
testers miss) problem.

Give up on this misguided idea and build on the best tools that are 
already available.
