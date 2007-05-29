Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbXE2JfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbXE2JfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 05:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXE2Jev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 05:34:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbXE2Jeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 05:34:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070527161252.GA12804@fieldses.org>
References: <20070527161252.GA12804@fieldses.org> <20070527022502.GB10867@fieldses.org> <20070526022342.GA20905@fieldses.org> <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com> <7436.1180223730@redhat.com> <18750.1180255870@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Tue, 29 May 2007 10:34:41 +0100
Message-ID: <28654.1180431281@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> You can contrive examples of applications that would be correct given
> the standard fcntl behavior, but that would deadlock on a system that
> didn't allow read locks to jump the queue in the above situation.

Yes, but you can also contrive starvation if you allow locks to jump the
queue.  Obviously, the Linux kernel behaviour is to allow readlocks to jump
the queue if a readlock is currently in force, so I have to conform to that,
whether I like it or not.

I'll need to test the upgrade/downgrade case.  I don't know whether the AFS
server supports that.  If it doesn't, I can emulate downgrade, but not upgrade
- not unless I only ever ask it for exclusive locks.

Lock upgrading is really, really easy to contrive deadlock for.

David
