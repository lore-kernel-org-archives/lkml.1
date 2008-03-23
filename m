Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYCWQA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYCWQA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 12:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbYCWQAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 12:00:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36812 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbYCWQAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 12:00:10 -0400
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
From: Dave Hansen <haveblue@us.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       ?ric Piel <Eric.Piel@tremplin-utc.net>, Tilman Schmidt <tilman@imap.cc>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>,
       Eric Biederman <ebiederm@xmission.com>
In-Reply-To: <20080321131737.GC5331@ucw.cz>
References: <1205517802.12763.18.camel@nimitz.home.sr71.net>
	 <1205525184.12763.32.camel@nimitz.home.sr71.net>
	 <47DAE55C.3080506@tremplin-utc.net>
	 <1205530551.8167.20.camel@nimitz.home.sr71.net>
	 <47DB013D.3060102@tremplin-utc.net>
	 <1205537395.8167.31.camel@nimitz.home.sr71.net> <47DBC578.7050101@imap.cc>
	 <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org>
	 <47DC26BC.7060502@tremplin-utc.net>
	 <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org>
	 <20080321131737.GC5331@ucw.cz>
Content-Type: text/plain
Date: Sun, 23 Mar 2008 09:00:04 -0700
Message-Id: <1206288004.30471.45.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-21 at 14:17 +0100, Pavel Machek wrote:
> > So what's the reason for pushing for this insanely-early workaround in the 
> > first place, instead of letting user-space do something like
> > 
> >       cat my-dsdt-image > /proc/sys/acpi/DSDT
> > 
> > or whatever at runtime?
> 
> You have interpretted code runing (AML), and you want to replace it
> with different code?
> 
> Akin to changing from one kernel to different during runtime?

Heh.  That gave me an idea.

Can we use kexec for this?  Let's say you get as far in boot as the
initrd and realize that you're running on one of these screwed up
systems.  Can you stick the new DSDT somewhere known (and safe) in
memory, and kexec yourself back to the beginning of the kernel boot?

When you boot up the second time, you have the new, shiny DSDT there
which is, of course, used instead of the bogus BIOS one.

It costs you some bootup time, but we're talking about working around
really busted hardware here.  

-- Dave

