Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYHODGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYHODGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYHODGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:06:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbYHODGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:06:24 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
	alinuxinterfaceforon	access scanning
From: Eric Paris <eparis@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Rik van Riel <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Pavel Machek <pavel@suse.cz>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080815004335.GF13048@mit.edu>
References: <20080813125638.GB6995@ucw.cz>
	 <20080813135207.CC08C3765BC@pmx1.sophos.com>
	 <20080814125410.GA2262@elf.ucw.cz>
	 <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>
	 <20080814223918.GC6370@elf.ucw.cz>
	 <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 23:00:09 -0400
Message-Id: <1218769209.16613.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 20:43 -0400, Theodore Tso wrote:
> On Thu, Aug 14, 2008 at 08:00:05PM -0400, Rik van Riel wrote:
> > > Yes, that's the part libmalware.so proposal solves. Given scary number
> > > of 0 Linux viruses in wild, it seems to solve the problem pretty well.
> > 
> > If you're trolling, you're not being very good at it.
> > 
> > Just because you cannot easily infect a Linux system from a
> > user application does not mean malware cannot do all kinds
> > of damage with user privileges.  Think of a key sniffer (using
> > the same interface that the X screensavers use) or a spam bot
> > running with user privileges.
> 
> But Pavel is raising a good question.  In Eric's proposed threat
> model, he claimed the only thing that he was trying to solve was
> "scanning".  Just file scanning.  That implies no root privileges, but
> it also implied that he wasn't worried about malware running with user
> privileges, either.  Presumbly, that would be caught and stopped by
> the file scanner before the malware had a chance to run; that is the
> execve(2) system call would also be blocked until the executable was
> scanned.
> 
> So if that is the threat model, then the only thing libmalware.so
> doesn't solve is knfsd access, and it should be evaluated on that
> basis.  If the threat model *does* include malware which is **not**
> caught by the AV scanner, and is running with user privileges, then
> there are a whole host of other attacks that we have to worry about.
> So let's be real clear, up front, what the threat model is, and avoid
> changing the model around to rule out solutions that don't fit the
> initially preconceived one.  That's how you get to the TSA
> confiscating water bottles in airport security lines.

No, I'm not claiming to protect against running processes.  I'll leave
that for SELinux.

I haven't seen this supposed libmalware.so so take anything I say with a
grain of sand.  But I take it that the solutions to the problems are
'don't do that.'

aka malware is allowed to flow freely across linux nfs servers.  Great,
I'm sure corperate IT organizations are going to love knowing there
isn't a darn thing they can do to protect their nfs server from being
storage grounds other than hope they can control all of the border.

And I still don't get this 'mmap problem' that I don't solve that
libmalware magically solves.  What?  don't use mmap?  I certainly hope
not.

Are we seriously considering that the right thing to do is to try to
push malware scanning to every project on sourceforge?  At least putting
a solution inside glibc wasn't completely insane, I just think for
numerous reasons we've seen on list for the last 2 weeks not a better
idea.  In any case, having an application have to make special calls to
handle 'untrusted' data is basically like turning the keys to the castle
over on every exploit.  No, I might not make promises about subverted
applications, but that doesn't mean I have to just open all the doors.
And anything that requires explicit application help is just that.  Talk
about theater.

-Eric

