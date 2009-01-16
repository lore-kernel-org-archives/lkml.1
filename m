Return-Path: <linux-kernel-owner+w=401wt.eu-S1760959AbZAPLZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbZAPLZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbZAPLZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:25:35 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:42261 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbZAPLZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:25:34 -0500
Date: Fri, 16 Jan 2009 12:24:35 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Pavel Machek <pavel@suse.cz>
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
Message-ID: <20090116112435.GB27146@osiris.boeblingen.de.ibm.com>
References: <20090115194806.804618825@mini.kroah.org> <20090115195848.GP14419@kroah.com> <20090116110029.GA28778@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116110029.GA28778@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 12:00:29PM +0100, Pavel Machek wrote:
> 
> > 2.6.28-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > commit 58fd3aa288939d3097fa04505b25c2f5e6e144d1 upstream.
> > 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> That does not make review exactly easy. Would it be possible to
> inline upstream comment in the commit message?
> 
> ...upstream commit message is empty :-(.

Yes, what should it contain anyway?
"This converts the first 10 system calls to the system call wrapper
infrastructure"? IMHO the subject says enough.

> > -asmlinkage long
> > -sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
> > +SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
> > +		struct timespec __user *, rmtp)
> >  {
> >  	struct timespec tu;
> >  
> 
> Is it strictly neccessary to modify all the syscalls? 

Not strictly necessary, but much easier to maintain in the long term.
It's simply a just convert 'em all approach and never think again about
this.

Plus the ugliness of the 64 bit parameter special case handling makes it
unlikely that we will ever have again a discussion how a new system call
should pass an loff_t.
