Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYBKRb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYBKRb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbYBKRbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:31:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638AbYBKRbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:31:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Xine.LNX.4.64.0802112156030.27028@us.intercode.com.au>
References: <Xine.LNX.4.64.0802112156030.27028@us.intercode.com.au> <20080208165156.15902.62457.stgit@warthog.procyon.org.uk> <20080208165235.15902.8174.stgit@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/37] Security: De-embed task security record from task and use refcounting
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 11 Feb 2008 17:30:36 +0000
Message-ID: <28534.1202751036@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > Remove the temporarily embedded task security record from task_struct.
> > Instead it is made to dangle from the task_struct::sec and
> > task_struct::act_as pointers with references counted for each.
> 
> ...
> 
> These patches are kind of huge.

Yeah, I know.  The problem is that each patch must compile and run.  They
can't be split up without violating that unfortunately.

> Why manually copy these fields after a kmemdup?

Fair point.  Fixed.

> What about the task backpointer? (i.e. tsec2->task)

The problem is that there can't be one with this patch as the task_security
struct and the LSM security data attached to it may outlive the task it points
back to.

It seems that the backpointer can be dispensed with.  Nothing particularly
seems to use it.  Do you know the reason for its existence?

David
