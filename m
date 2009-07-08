Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbZGHLDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbZGHLDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZGHLDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:03:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59786 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbZGHLDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:03:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090704024606.GE1345@ucw.cz>
References: <20090704024606.GE1345@ucw.cz> <20090701120814.30741.10146.stgit@warthog.procyon.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: dhowells@redhat.com, vapier.adi@gmail.com, rgetz@blackfin.uclinux.org,
       lethal@linux-sh.org, gerg@uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FDPIC: Ignore the loader's PT_GNU_STACK when calculating the stack size
Date: Wed, 08 Jul 2009 12:01:40 +0100
Message-ID: <24530.1247050900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> The patch seems wrong to me; loader needs the stack, too, right?
> 
> What about making sure that the loader specifies reasonable stack
> size, instead?

The loader doesn't need its own stack, unless it _is_ the executable.  It uses
the executable's stack.  The problem is that the executable and the loader can
both specify the stack size for NOMMU, but which one do we pick, or do we
consider both.

David
