Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYCNLq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYCNLq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYCNLqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:46:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbYCNLqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:46:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080313152850.c76ab240.akpm@linux-foundation.org>
References: <20080313152850.c76ab240.akpm@linux-foundation.org> <20080313191432.28959.52722.stgit@warthog.procyon.org.uk> <20080313191442.28959.28152.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, kwc@citi.umich.edu,
       arunsr@cse.iitk.ac.in, dwalsh@redhat.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KEYS: Make the keyring quotas controllable through /proc/sys
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 14 Mar 2008 11:46:08 +0000
Message-ID: <31114.1205495168@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > +#ifdef CONFIG_SYSCTL
> > +extern ctl_table key_sysctls[];
> > +#endif
> 
> I've been going around telling people to not bother with the ifdefs here. 
> Upside: looks nicer.  Downside: defers the build error from compile-time to
> link-time.

Should this extern actually be in include/linux/sysctl.h?  I'd rather not put
it in include/linux/key.h as that means that key.h must include sysctl.h just
to get a definition of ctl_table.  Conversely, however, sysctl.h doesn't need
to include key.h to include the above extern.

David
