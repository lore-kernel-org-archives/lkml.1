Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbXKMRCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbXKMRCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXKMRB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:01:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854AbXKMRB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:01:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20134.1194968670@redhat.com>
References: <20134.1194968670@redhat.com> <20071109115207.e435f19b.akpm@linux-foundation.org> <20071106214820.3854.17402.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jdi@l4x.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the extern declaration of kallsyms_num_syms
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 13 Nov 2007 17:01:48 +0000
Message-ID: <23195.1194973308@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > > +extern const unsigned long kallsyms_num_syms
> > > +__nongpreldata __attribute__((weak));

Rather than using __nongpreldata, I should be able to say that it's in
.rodata - which seems to be more correct anyway - and throw into a comment to
say why.

I can't quite work out, though, how the kernel build stuff gets the datum into
the kernel build.  I can see there's a script, but I never see the output of
the script crop up anywhere in the build tree:-/  GDB reports, though, that
kallsyms_num_syms gets the right value.

David
