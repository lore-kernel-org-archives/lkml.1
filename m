Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbYH1KEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbYH1KEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYH1KEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:04:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49857 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751266AbYH1KEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:04:05 -0400
Date: Thu, 28 Aug 2008 10:45:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/59] Introduce credentials
Message-ID: <20080828104503.68f42b28@lxorguk.ukuu.org.uk>
In-Reply-To: <4235.1219915184@redhat.com>
References: <20080827173950.02afc804@lxorguk.ukuu.org.uk>
	<20080827143355.5b8bfcf1@lxorguk.ukuu.org.uk>
	<20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	<21723.1219847044@redhat.com>
	<4235.1219915184@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 10:19:44 +0100
David Howells <dhowells@redhat.com> wrote:

> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > We get a number of things:
> > > 
> > >  (1) Multiple credential changes all happen simultaneously (setresuid() for
> > >      example).  The new set of credentials is committed with a single RCU
> > >      assignment.
> > 
> > Makes sense - except for the question of bounding memory utilisation.
> 
> Would it make sense to call synchronise_rcu() from commit_creds() or from
> setuid()/setresuid()/setgroups()/etc. to make sure that some user process
> doing:
> 
> 	while (1)
> 		alter_credentials();
> 
> doesn't run the system out of memory by having loads of frees waiting in RCU's
> queues because put_cred() uses call_rcu() to defer the destruction.

I suspect you to - or every "nth" event - building up a small queue as
would occur in normal usage probably isn't a problem.
