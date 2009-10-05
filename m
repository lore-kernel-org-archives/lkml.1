Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZJENAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZJENAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 09:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbZJENAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 09:00:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560AbZJENAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 09:00:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4AC99292.5060502@redhat.com>
References: <4AC99292.5060502@redhat.com> <20090930032138.3919.72085.sendpatchset@localhost.localdomain> <9705.1254400470@redhat.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Brian Behlendorf <behlendorf1@llnl.gov>,
       Ben Woodard <bwoodard@llnl.gov>, Stable Team <stable@kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [Patch] rwsem: fix rwsem_is_locked() bug
Date: Mon, 05 Oct 2009 13:58:36 +0100
Message-ID: <16559.1254747516@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> wrote:

> FYI, this seems wrong, probably even worse than what it is now.
> I tried this change, it breaks portmap.

Sorry, my mistake.  The following:

> > -	woken = 0;
> > +	woken = ++sem->activity;

should have been:

-	woken = 0;
+	woken = sem->activity++;

David
