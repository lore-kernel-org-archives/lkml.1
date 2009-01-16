Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbZAPIq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbZAPIq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbZAPIqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:46:15 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:45009 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbZAPIqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:46:14 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [patch 27/85] [PATCH 07/44] [CVE-2009-0029] System call wrapper infrastructure
Date: Fri, 16 Jan 2009 09:44:59 +0100
User-Agent: KMail/1.9.9
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
       alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20090115215237.906089480@mini.kroah.org> <20090115215950.GB17227@kroah.com> <496FBCD1.5050608@gmail.com>
In-Reply-To: <496FBCD1.5050608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901160944.59773.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 Januar 2009 schrieb Jiri Slaby:
> On 01/15/2009 10:59 PM, Greg KH wrote:
> > +
> > +#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
> > +
> > +#define SYSCALL_DEFINE(name) static inline long SYSC_##name
> > +#define SYSCALL_DEFINEx(x, name, ...)                                        
\
> > +     asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__));          \
> > +     static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__));      \
> 
> Hmm, we don't support at least gcc 3.4.6 anymore :/. It seems to be the same 
as in:

I see two possible quick fixes:
-funit-at-a-time will allow these inline constructs (tested with 3.4.6 on i386 
with enabled syscall wrappers. x86_64 already sets this flag)

- dont use attribute __always_inline__ for these inlines but the standard 
inline. The question is, how to convince cpp to not replace inline with 
always_inline
