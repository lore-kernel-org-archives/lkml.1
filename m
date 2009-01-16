Return-Path: <linux-kernel-owner+w=401wt.eu-S935030AbZAPOlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030AbZAPOlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZAPOlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:41:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43751 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbZAPOlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:41:01 -0500
Date: Fri, 16 Jan 2009 15:43:04 +0100
From: Pavel Machek <pavel@suse.cz>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jbenc@suse.cz
Subject: Re: [patch 42/94] [PATCH 11/44] [CVE-2009-0029] System call
	wrappers part 01
Message-ID: <20090116144304.GB1933@elf.ucw.cz>
References: <20090115194806.804618825@mini.kroah.org> <20090115195848.GP14419@kroah.com> <20090116110029.GA28778@atrey.karlin.mff.cuni.cz> <20090116112435.GB27146@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116112435.GB27146@osiris.boeblingen.de.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-16 12:24:35, Heiko Carstens wrote:
> On Fri, Jan 16, 2009 at 12:00:29PM +0100, Pavel Machek wrote:
> > 
> > > 2.6.28-stable review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > 
> > > commit 58fd3aa288939d3097fa04505b25c2f5e6e144d1 upstream.
> > > 
> > > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > That does not make review exactly easy. Would it be possible to
> > inline upstream comment in the commit message?
> > 
> > ...upstream commit message is empty :-(.
> 
> Yes, what should it contain anyway?
> "This converts the first 10 system calls to the system call wrapper
> infrastructure"? IMHO the subject says enough.

"This converts the first 10 system calls to the system call wrapper
infrastructure. This is neccessary because of <description of security
hole>. It is good idea to convert all syscalls and not only affected
ones for uniformity."

....at the very least.

> > > -asmlinkage long
> > > -sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
> > > +SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
> > > +		struct timespec __user *, rmtp)
> > >  {
> > >  	struct timespec tu;
> > >  
> > 
> > Is it strictly neccessary to modify all the syscalls? 
> 
> Not strictly necessary, but much easier to maintain in the long term.
> It's simply a just convert 'em all approach and never think again about
> this.

I believe we should go for minimal patch for -stable. This is really
huge.

> Plus the ugliness of the 64 bit parameter special case handling makes it
> unlikely that we will ever have again a discussion how a new system call
> should pass an loff_t.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
