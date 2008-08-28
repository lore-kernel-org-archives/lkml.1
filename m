Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbYH1JUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbYH1JUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYH1JTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:19:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYH1JTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:19:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080827173950.02afc804@lxorguk.ukuu.org.uk>
References: <20080827173950.02afc804@lxorguk.ukuu.org.uk> <20080827143355.5b8bfcf1@lxorguk.ukuu.org.uk> <20080827134541.19980.61042.stgit@warthog.procyon.org.uk> <21723.1219847044@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/59] Introduce credentials
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Thu, 28 Aug 2008 10:19:44 +0100
Message-ID: <4235.1219915184@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > We get a number of things:
> > 
> >  (1) Multiple credential changes all happen simultaneously (setresuid() for
> >      example).  The new set of credentials is committed with a single RCU
> >      assignment.
> 
> Makes sense - except for the question of bounding memory utilisation.

Would it make sense to call synchronise_rcu() from commit_creds() or from
setuid()/setresuid()/setgroups()/etc. to make sure that some user process
doing:

	while (1)
		alter_credentials();

doesn't run the system out of memory by having loads of frees waiting in RCU's
queues because put_cred() uses call_rcu() to defer the destruction.

David
