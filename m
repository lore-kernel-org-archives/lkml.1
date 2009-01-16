Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbZAPJ6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbZAPJ6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761684AbZAPJ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:58:34 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38852 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZAPJ6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:58:32 -0500
Date: Fri, 16 Jan 2009 10:57:47 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
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
       alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 27/85] [PATCH 07/44] [CVE-2009-0029] System call
	wrapper infrastructure
Message-ID: <20090116095747.GE5157@osiris.boeblingen.de.ibm.com>
References: <20090115215237.906089480@mini.kroah.org> <20090115215950.GB17227@kroah.com> <496FBCD1.5050608@gmail.com> <200901160944.59773.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901160944.59773.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 09:44:59AM +0100, Christian Borntraeger wrote:
> Am Donnerstag 15 Januar 2009 schrieb Jiri Slaby:
> > On 01/15/2009 10:59 PM, Greg KH wrote:
> > > +
> > > +#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
> > > +
> > > +#define SYSCALL_DEFINE(name) static inline long SYSC_##name
> > > +#define SYSCALL_DEFINEx(x, name, ...)                                        
> \
> > > +     asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__));          \
> > > +     static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__));      \
> > 
> > Hmm, we don't support at least gcc 3.4.6 anymore :/. It seems to be the same 
> as in:
> 
> I see two possible quick fixes:
> -funit-at-a-time will allow these inline constructs (tested with 3.4.6 on i386 
> with enabled syscall wrappers. x86_64 already sets this flag)

If that helps: care to send a patch that enables this?
Dependent on CONFIG_HAVE_SYSCALL_WRAPPERS?

That is, if this is really a problem.
