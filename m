Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZIDIpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZIDIpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZIDIp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:45:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbZIDIp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:45:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090903200924.E46DF47C94@magilla.sf.frob.com>
References: <20090903200924.E46DF47C94@magilla.sf.frob.com> <20090903160514.GA23646@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
Date: Fri, 04 Sep 2009 09:43:40 +0100
Message-ID: <30013.1252053820@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote:

> I certainly think it's right to hold the mutex only as long as necessary.
> Clearly holding it when we stop is wrong.

As far as I can tell, we don't hold it when we stop for debugging, or stop on
signal.

> I'm a bit concerned about holding it for arbitrary periods while we block
> in the filesystem code.  e.g., consider the scenario with a hangs-forever
> NFS server or suchlike.  But I'm not sure there is a reasonable way around
> that one.

If you drop the sem before committing the creds, you have to recalculate the
new credentials.

> The paired calls that leave the mutex locked in between should have some
> clear comments calling attention to their pairing.  Aside from that making
> sure that subtlety is clear, I don't see any problems in the patch off hand.
> But I haven't scoured the code path lately to have full confidence.
> I'd like to hear David's reactions.

Looking at the patch description, I don't see how the patch it relevant to the
problem.  There must be something else, either a call that's now being
skipped, or it's a matter of timing.

David
