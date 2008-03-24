Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbYCXRFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbYCXRFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYCXRF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:05:26 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:19801 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbYCXRFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:05:25 -0400
X-Spam-Flag: NO
X-Spam-Score: -6.389
Message-ID: <47E7DF4A.4090007@tremplin-utc.net>
Date: Mon, 24 Mar 2008 18:05:14 +0100
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.12) Gecko/20080305 Mandriva/2.0.0.12-3mdv2008.1 (2008.1) Thunderbird/2.0.0.12 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tilman Schmidt <tilman@imap.cc>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
References: <47DAE55C.3080506@tremplin-utc.net> <1205530551.8167.20.camel@nimitz.home.sr71.net> <47DB013D.3060102@tremplin-utc.net> <1205537395.8167.31.camel@nimitz.home.sr71.net> <47DBC578.7050101@imap.cc> <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org> <47DC26BC.7060502@tremplin-utc.net> <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org> <20080321131737.GC5331@ucw.cz> <1206288004.30471.45.camel@nimitz.home.sr71.net> <20080324160333.GD4069@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080324160333.GD4069@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>> Can we use kexec for this?  Let's say you get as far in boot as the
>> initrd and realize that you're running on one of these screwed up
>> systems.  Can you stick the new DSDT somewhere known (and safe) in
>> memory, and kexec yourself back to the beginning of the kernel boot?
>>
>> When you boot up the second time, you have the new, shiny DSDT there
>> which is, of course, used instead of the bogus BIOS one.
>>
>> It costs you some bootup time, but we're talking about working around
>> really busted hardware here.  
> 
> Hmmm. I guess we should turn off acpi mode, kexec, turn on acpi mode
> with new dsdt.
> 
> Turning off acpi is not exactly easy, but specs describe how to do
> it...
Why do you think it's necessary to turn off acpi mode? What will not 
work if we keep it on all the time?

BTW, let me summarize my understanding of the kexec approach:
* the userspace write the new DSDT (cat my-dsdt-image > 
/sys/firmware/acpi/tables/DSDT)
* the kernel don't use this DSDT directly but keeps it somewhere warm 
and fuzzy in the RAM
* userspace does a kexec
* the new kernel boots and at some (early) point, dsdt_override() is 
called. It detects that the special place in the RAM for a new DSDT is 
used. It provides this pointer to ACPI as the new place to read the DSDT.

Dave, am I correctly understanding the scenario you had in mind?

I have pratically no knowledge of kexec. Is there a documented way to 
pass big chunk of data from one kernel to another one? How can I do that?

Eric
