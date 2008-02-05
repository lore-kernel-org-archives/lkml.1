Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYBEQS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYBEQS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYBEQST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:18:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50868 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751837AbYBEQSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:18:18 -0500
Date: Tue, 5 Feb 2008 17:18:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [regression] Re: brk randomization breaks columns
Message-ID: <20080205161810.GF24331@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <20080205110632.GB3758@elf.ucw.cz> <Pine.LNX.4.64.0802051216340.30955@jikos.suse.cz> <20080205125426.GA27724@elte.hu> <20080205130546.GF30691@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205130546.GF30691@devserv.devel.redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-05 08:05:46, Jakub Jelinek wrote:
> On Tue, Feb 05, 2008 at 01:54:26PM +0100, Ingo Molnar wrote:
> > * Jiri Kosina <jkosina@suse.cz> wrote:
> > 
> > > On Tue, 5 Feb 2008, Pavel Machek wrote:
> > > 
> > > > > Actually, this clearly shows that either prehistoric libc.so.5 or the 
> > > > > program itself are broken.
> > > > I believe it shows clear regression in latest 2.6.25 kernel.
> > > 
> > > I am still not completely sure. It might be a regression, but it also 
> > > might just trigger the bug in ancient version in libc.so.5 which might 
> > > be fixed in some later version [...]
> > 
> > which too is a regression ...
> > 
> > really, lets add a sysctl for this, and a .config option that either 
> > disables or enables it. Then we will default to disabled. (but users can 
> > enable it - and distros can build their kernels with this .config option 
> > enabled)
> 
> I don't think kernel should care about programs which are buggy and make invalid
> assumptions, and that's the case here.  I remember we have been

Those "invalid assumptions" crept into documentation. Everybody knew
heap starts at the end of bss in 1995.

> 5 years ago when brk randomization has been added to Red Hat kernels.  There was
> one or two broken programs which made assumptions on what brk(0) is supposed
> to return at program startup, everything else was ok.

That's not the problem. Problem is that programs assume
brk(0x12345678) allocates space between end of bss and 0x12345678;
which is no longer the case.

And actually even
http://opengroup.org/onlinepubs/007908775/xsh/brk.html only talks
about "ammount of space"... implying begging of that space is well
known.

								Pavel
PS: It would be nice to fix linux man pages to say that it brk() moves
end of the heap, only, and that any usage of brk() is invalid w/o
doing brk(0) before.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
