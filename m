Return-Path: <linux-kernel-owner+w=401wt.eu-S936158AbZAPPZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936158AbZAPPZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935892AbZAPPYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:24:42 -0500
Received: from kroah.org ([198.145.64.141]:39864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935714AbZAPPYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:24:40 -0500
Date: Fri, 16 Jan 2009 07:00:04 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Eugene Teo <eteo@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Greg KH <gregkh@suse.de>, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>, jbenc@suse.cz,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 42/94] [PATCH 11/44] [CVE-2009-0029] System
	call wrappers part 01
Message-ID: <20090116150004.GA9212@kroah.com>
References: <20090115194806.804618825@mini.kroah.org> <20090115195848.GP14419@kroah.com> <20090116110029.GA28778@atrey.karlin.mff.cuni.cz> <20090116112435.GB27146@osiris.boeblingen.de.ibm.com> <20090116144304.GB1933@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116144304.GB1933@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 03:43:04PM +0100, Pavel Machek wrote:
> On Fri 2009-01-16 12:24:35, Heiko Carstens wrote:
> > On Fri, Jan 16, 2009 at 12:00:29PM +0100, Pavel Machek wrote:
> > > 
> > > > 2.6.28-stable review patch.  If anyone has any objections, please let us know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > > 
> > > > commit 58fd3aa288939d3097fa04505b25c2f5e6e144d1 upstream.
> > > > 
> > > > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > That does not make review exactly easy. Would it be possible to
> > > inline upstream comment in the commit message?
> > > 
> > > ...upstream commit message is empty :-(.
> > 
> > Yes, what should it contain anyway?
> > "This converts the first 10 system calls to the system call wrapper
> > infrastructure"? IMHO the subject says enough.
> 
> "This converts the first 10 system calls to the system call wrapper
> infrastructure. This is neccessary because of <description of security
> hole>. It is good idea to convert all syscalls and not only affected
> ones for uniformity."
> 
> ....at the very least.
> 
> > > > -asmlinkage long
> > > > -sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
> > > > +SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
> > > > +		struct timespec __user *, rmtp)
> > > >  {
> > > >  	struct timespec tu;
> > > >  
> > > 
> > > Is it strictly neccessary to modify all the syscalls? 
> > 
> > Not strictly necessary, but much easier to maintain in the long term.
> > It's simply a just convert 'em all approach and never think again about
> > this.
> 
> I believe we should go for minimal patch for -stable. This is really
> huge.

Well, it's spread over 44 patches, but the end result is not that much.
And yes, based on the problem, it is required for -stable.

thanks,

greg k-h
