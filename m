Return-Path: <linux-kernel-owner+w=401wt.eu-S1761266AbYCXRTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266AbYCXRTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbYCXRSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:18:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58533 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931AbYCXRSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:18:48 -0400
Date: Mon, 24 Mar 2008 18:19:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>
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
Message-ID: <20080324171924.GB3782@elf.ucw.cz>
References: <47DB013D.3060102@tremplin-utc.net> <1205537395.8167.31.camel@nimitz.home.sr71.net> <47DBC578.7050101@imap.cc> <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org> <47DC26BC.7060502@tremplin-utc.net> <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org> <20080321131737.GC5331@ucw.cz> <1206288004.30471.45.camel@nimitz.home.sr71.net> <20080324160333.GD4069@atrey.karlin.mff.cuni.cz> <47E7DF4A.4090007@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E7DF4A.4090007@tremplin-utc.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-24 18:05:14, Eric Piel wrote:
> Pavel Machek wrote:
>> Hi!
>>> Can we use kexec for this?  Let's say you get as far in boot as the
>>> initrd and realize that you're running on one of these screwed up
>>> systems.  Can you stick the new DSDT somewhere known (and safe) in
>>> memory, and kexec yourself back to the beginning of the kernel boot?
>>>
>>> When you boot up the second time, you have the new, shiny DSDT there
>>> which is, of course, used instead of the bogus BIOS one.
>>>
>>> It costs you some bootup time, but we're talking about working around
>>> really busted hardware here.  
>>
>> Hmmm. I guess we should turn off acpi mode, kexec, turn on acpi mode
>> with new dsdt.
>>
>> Turning off acpi is not exactly easy, but specs describe how to do
>> it...
> Why do you think it's necessary to turn off acpi mode? What will not work 
> if we keep it on all the time?
>
> BTW, let me summarize my understanding of the kexec approach:
> * the userspace write the new DSDT (cat my-dsdt-image > 
> /sys/firmware/acpi/tables/DSDT)
> * the kernel don't use this DSDT directly but keeps it somewhere warm and 
> fuzzy in the RAM
> * userspace does a kexec
> * the new kernel boots and at some (early) point, dsdt_override() is 
> called. It detects that the special place in the RAM for a new DSDT is 
> used. It provides this pointer to ACPI as the new place to read the
> DSDT.

Yes, and now ACPI layer tries to enable already enabled ACPI... which
is no-no according to spec, but you may be able to  get away with it.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
