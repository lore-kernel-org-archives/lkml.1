Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbYCXRXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbYCXRXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYCXRXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:23:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48508 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYCXRXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:23:35 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
From: Dave Hansen <haveblue@us.ibm.com>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tilman Schmidt <tilman@imap.cc>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Eric Biederman <ebiederm@xmission.com>
In-Reply-To: <47E7DF4A.4090007@tremplin-utc.net>
References: <47DAE55C.3080506@tremplin-utc.net>
	 <1205530551.8167.20.camel@nimitz.home.sr71.net>
	 <47DB013D.3060102@tremplin-utc.net>
	 <1205537395.8167.31.camel@nimitz.home.sr71.net> <47DBC578.7050101@imap.cc>
	 <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org>
	 <47DC26BC.7060502@tremplin-utc.net>
	 <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org>
	 <20080321131737.GC5331@ucw.cz>
	 <1206288004.30471.45.camel@nimitz.home.sr71.net>
	 <20080324160333.GD4069@atrey.karlin.mff.cuni.cz>
	 <47E7DF4A.4090007@tremplin-utc.net>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 10:23:25 -0700
Message-Id: <1206379405.30471.55.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-24 at 18:05 +0100, Eric Piel wrote:
> BTW, let me summarize my understanding of the kexec approach:
> * the userspace write the new DSDT (cat my-dsdt-image > 
> /sys/firmware/acpi/tables/DSDT)
> * the kernel don't use this DSDT directly but keeps it somewhere warm 
> and fuzzy in the RAM
> * userspace does a kexec
> * the new kernel boots and at some (early) point, dsdt_override() is 
> called. It detects that the special place in the RAM for a new DSDT is 
> used. It provides this pointer to ACPI as the new place to read the DSDT.
> 
> Dave, am I correctly understanding the scenario you had in mind?

Yeah, that's basically what I was thinking.

But, this is only for a case where we can't do the real runtime
replacement that Linus has been advocating.  That approach is clearly
superior, but I would imagine that it'll require some serious ACPI
surgery and won't cover things like if the SRAT table was messed up.

> I have pratically no knowledge of kexec. Is there a documented way to 
> pass big chunk of data from one kernel to another one? How can I do that?

Heh.  Documented, no.  What OS do you think this is? ;)  I'm not sure it
has ever been really needed before.  

At one point, kexec just make a copy of the e820 table to tell the new
kernel where it's ram was.  If you carved out a chunk of memory and set
it as reserved, the new kernel could go looking there.

kexec is Eric Biederman's (on cc) baby, and he might have some more
concrete suggestions for you.

-- Dave

