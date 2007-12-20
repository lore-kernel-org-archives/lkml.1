Return-Path: <linux-kernel-owner+w=401wt.eu-S1765990AbXLTRLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765990AbXLTRLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXLTRLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:11:45 -0500
Received: from 1002-12.lowesthosting.com ([207.44.144.97]:36683 "HELO
	1002-12.Lowesthosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754319AbXLTRLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:11:45 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2007 12:11:44 EST
Message-ID: <476A9FEB.2090508@iitiantech.com>
Date: Thu, 20 Dec 2007 09:01:31 -0800
From: Siva Prasad <siva@iitiantech.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: matthew@bytemark.co.uk
CC: linux-kernel@vger.kernel.org
Subject: Testing RAM from userspace / question about memmap= arguments
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

I worked on some thing similar. For one of our customer product that 
goes to defense and security markets, we had to support maximum possible 
memory test. We implemented a mechanism of pre-test to test the memory 
with walking 1's and 0's just before Linux kernel starts allocating 
serious memory for its use. That way, coverage was almost 99%. Once 
Linux boots, we do a very through test using various algorithms, however 
as you said coverage of memory is little less when we test the system 
after Linux boots up completely.

memtest86+ started as a very good alternative, until customer's customer 
started complaining about memory issues. Then we had no choice but to 
take this route and implement it ourselves from the scratch.

If you want 100% coverage, it may not be possible unless you do it in 
BIOS early on. If you take the route of implementing some simple memory 
test in Linux kernel before it starts allocating memory, you get very 
good % of coverage. Good Luck.

- Siva


Date: Thu, 20 Dec 2007 14:17:10 +0000

From: Matthew Bloch <matthew@bytemark.co.uk>

Subject: Re: Testing RAM from userspace / question about memmap=

      arguments

To: linux-kernel@vger.kernel.org

Message-ID: <fkdth6$d7g$1@ger.gmane.org>

Content-Type: text/plain; charset=ISO-8859-1

 

Jon Masters wrote:

 > On Tue, 2007-12-18 at 17:06 +0000, Matthew Bloch wrote:

 >

 >> I can see a few potential problems, but since my understanding of the

 >> low-level memory mapping is muddy at best, I won't speculate; I'd just

 >> appreciate any more expert views on whether this does work, or could be

 >> made to work.

 >

 > Yo,

 >

 > I don't think your testing approach is thorough enough. Clearly (knowing

 > your line of business - as a virtual machine provider), you want to do

 > pre-production testing as part of your provisioning. I would suggest

 > instead of using mlock() from userspace of simply writing a kernel

 > module that does this for every page of available memory.

 

Yes this is to improve the efficiency of server burn-ins.  I would

consider a kernel module, but I still wouldn't be able to test the

memory in which the kernel is sitting, which is my problem.  I'm not

sure even a kernel module could reliably test the memory in which it is

residing (memtest86+ relocates itself to do this).  Also I don't see how

  userspace testing is any less thorough than doing it in the kernel; I

just need a creative way of accessing every single page of memory.

 

I may do some experiments with the memmap args, some bad RAM and

shuffling it between DIMM sockets when I have the time :)

 

-- 

Matthew
