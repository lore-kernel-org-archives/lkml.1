Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbZDHV2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbZDHV2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759008AbZDHV2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:28:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33245 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458AbZDHV2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:28:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090408205610.GA9970@uranus.ravnborg.org>
References: <20090408205610.GA9970@uranus.ravnborg.org> <20090408184455.GB332@uranus.ravnborg.org> <21081.1239214221@redhat.com> <20090408183011.24150.43310.stgit@warthog.procyon.org.uk> <24317.1239216477@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, jeremy@goop.org, mingo@elte.hu,
       akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, nickpiggin@yahoo.com.au, tglx@linutronix.de,
       ysato@users.sourceforge.jp
Subject: Re: [PATCH] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
Date: Wed, 08 Apr 2009 22:25:55 +0100
Message-ID: <26753.1239225955@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> > > Any change we can have these header files moved before too
> > > many patches are queued?
> > 
> > Sure.  Do you have patches to move FRV and MN10300 headers?
> 
> For frv it is as simple as:
> 
> mkdir -p arch/frv/include/asm
> git mv include/asm-frv/* arch/frv/include/asm
> git commit

The thing I really detest about doing this is this:

	warthog>git-log -M arch/frv/include/asm/pgtable.h | cat
	commit 2203e07b4ba1d1113ab80e7c51062f6994a62d3a
	Author: David Howells <dhowells@redhat.com>
	Date:   Wed Apr 8 22:20:14 2009 +0100

	    FRV: Move to arch/frv/include/asm/

	    Move from include/asm-frv/ to arch/frv/include/asm/.

	    Signed-off-by: David Howells <dhowells@redhat.com>
	warthog>

So much for the old history:

	warthog>git-log include/asm-frv/pgtable.h | grep ^commit | wc -l
	20
	warthog>

David
