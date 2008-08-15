Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYHOAoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYHOAoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 20:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYHOAn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 20:43:58 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54020 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750999AbYHOAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 20:43:57 -0400
Date: Thu, 14 Aug 2008 20:43:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Rik van Riel <riel@redhat.com>
Cc: Pavel Machek <pavel@suse.cz>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       davecb@sun.com, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
	access scanning
Message-ID: <20080815004335.GF13048@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@suse.cz>,
	"Press, Jonathan" <Jonathan.Press@ca.com>, davecb@sun.com,
	Adrian Bunk <bunk@kernel.org>,
	Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
	malware-list@lists.printk.net,
	linux-security-module@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814200005.6b363716@bree.surriel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 08:00:05PM -0400, Rik van Riel wrote:
> > Yes, that's the part libmalware.so proposal solves. Given scary number
> > of 0 Linux viruses in wild, it seems to solve the problem pretty well.
> 
> If you're trolling, you're not being very good at it.
> 
> Just because you cannot easily infect a Linux system from a
> user application does not mean malware cannot do all kinds
> of damage with user privileges.  Think of a key sniffer (using
> the same interface that the X screensavers use) or a spam bot
> running with user privileges.

But Pavel is raising a good question.  In Eric's proposed threat
model, he claimed the only thing that he was trying to solve was
"scanning".  Just file scanning.  That implies no root privileges, but
it also implied that he wasn't worried about malware running with user
privileges, either.  Presumbly, that would be caught and stopped by
the file scanner before the malware had a chance to run; that is the
execve(2) system call would also be blocked until the executable was
scanned.

So if that is the threat model, then the only thing libmalware.so
doesn't solve is knfsd access, and it should be evaluated on that
basis.  If the threat model *does* include malware which is **not**
caught by the AV scanner, and is running with user privileges, then
there are a whole host of other attacks that we have to worry about.
So let's be real clear, up front, what the threat model is, and avoid
changing the model around to rule out solutions that don't fit the
initially preconceived one.  That's how you get to the TSA
confiscating water bottles in airport security lines.

	     	   	      	      	       - Ted
