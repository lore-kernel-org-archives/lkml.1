Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZBTPok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZBTPok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbZBTPoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:44:30 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34174 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbZBTPo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:44:29 -0500
Subject: Re: kvm-userspace build break (linux/types.h)
From: Hollis Blanchard <hollisb@us.ibm.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Joerg Roedel <joro@8bytes.org>, xiantao.zhang@intel.com
In-Reply-To: <1235106727.3826.13.camel@localhost.localdomain>
References: <1235080214.16221.26.camel@slate.austin.ibm.com>
	 <1235106727.3826.13.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM Linux Technology Center
Date: Fri, 20 Feb 2009 09:44:25 -0600
Message-Id: <1235144665.3745.3.camel@slate.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-20 at 10:42 +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-02-19 at 15:50 -0600, Hollis Blanchard wrote:
> > A recent kernel merge breaks kvm-userspace build:
> >         make[1]: Entering directory `/root/hollisb/kvm-userspace.git/libkvm'
> >         gcc -m64 -D__x86_64__ -MMD -MF ./.libkvm.d -g -fomit-frame-pointer -Wall  -fno-stack-protector   -I /root/hollisb/kvm-userspace.git/kernel/include   -c -o libkvm.o libkvm.c
> >         In file included from /usr/include/bits/fcntl.h:24,
> >                          from /usr/include/fcntl.h:34,
> >                          from libkvm.c:30:
> >         /usr/include/sys/types.h:46: error: conflicting types for ‘loff_t’
> >         /usr/include/linux/types.h:30: error: previous declaration of ‘loff_t’ was here
> >         /usr/include/sys/types.h:62: error: conflicting types for ‘dev_t’
> >         /usr/include/linux/types.h:13: error: previous declaration of ‘dev_t’ was here
> >         [...]
> > 
> > I built like so:
> >         ./configure
> >         make -C kernel LINUX=/path/to/kvm.git sync
> >         make
> > 
> > The problem appears to be 00bfddaf7f68a6551319b536f052040c370756b0 and
> > cef3767852a9b1a7ff4a8dfe0969e2d32eb728df, both from Jaswinder Singh
> > Rajput <jaswinder@infradead.org>: 
> >         -#include <asm/types.h>
> >         +#include <linux/types.h>
> > 
> > With these changes, libkvm.c ends up
> > including /usr/include/linux/types.h, instead of the
> > intended ../kernel/include/linux/types.h.
> > 
> > Avi, suggestions? More "make sync" hacks?
> > 
> 
> Avi, Is this already fixed, Or it is in your Magic Box (patch queue ;-)

Sorry, my fault... it is already fixed in the master branch of Avi's
tree.

> Hollis: Do you mind testing -tip tree, may be we already fixed your
> problem, Ingo is having big Magic Box :)
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=summary

Avi, would you pull kvm-userspace
05acb1ae99a8b55c9745f2e566010213cf52a819 into maint/2.6.29 branch
please?

-- 
Hollis Blanchard
IBM Linux Technology Center

