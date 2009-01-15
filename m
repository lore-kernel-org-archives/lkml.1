Return-Path: <linux-kernel-owner+w=401wt.eu-S935132AbZAOXpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935132AbZAOXpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZAOXpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 18:45:17 -0500
Received: from kroah.org ([198.145.64.141]:33547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752760AbZAOXpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 18:45:15 -0500
Date: Thu, 15 Jan 2009 15:42:37 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, alan@lxorguk.ukuu.org.uk,
       Eugene Teo <eteo@redhat.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, Jake Edge <jake@lwn.net>,
       Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Willy Tarreau <w@1wt.eu>
Subject: Re: [stable] [patch 27/85] [PATCH 07/44] [CVE-2009-0029] System
	call wrapper infrastructure
Message-ID: <20090115234237.GA20132@kroah.com>
References: <20090115215237.906089480@mini.kroah.org> <20090115215950.GB17227@kroah.com> <496FBCD1.5050608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496FBCD1.5050608@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:46:41PM +0100, Jiri Slaby wrote:
> On 01/15/2009 10:59 PM, Greg KH wrote:
> > +
> > +#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
> > +
> > +#define SYSCALL_DEFINE(name) static inline long SYSC_##name
> > +#define SYSCALL_DEFINEx(x, name, ...)                                        \
> > +     asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__));          \
> > +     static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__));      \
> 
> Hmm, we don't support at least gcc 3.4.6 anymore :/. It seems to be the same as in:
> http://lkml.org/lkml/2007/12/6/385
> 
> It doesn't like inline prototypes.

Hm, Heiko, any ideas?

thanks,

greg k-h
