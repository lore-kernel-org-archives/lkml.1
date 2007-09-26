Return-Path: <linux-kernel-owner+w=401wt.eu-S1761908AbXIZSYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908AbXIZSYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761366AbXIZSXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:23:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57609 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761338AbXIZSXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:23:33 -0400
Date: Wed, 26 Sep 2007 19:23:22 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morgan <morgan@kernel.org>
Cc: David Howells <dhowells@redhat.com>, hch@infradead.org,
       Trond.Myklebust@netapp.com, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] CRED: Move the effective capabilities into the cred struct
Message-ID: <20070926182322.GQ8181@ftp.linux.org.uk>
References: <20070919161749.8334.26064.stgit@warthog.procyon.org.uk> <20070919161805.8334.96808.stgit@warthog.procyon.org.uk> <46F1F2EE.1010904@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F1F2EE.1010904@kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 09:11:26PM -0700, Andrew Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> David Howells wrote:
> > Move the effective capabilities mask from the task struct into the credentials
> > record.
> > 
> > Note that the effective capabilities mask in the cred struct shadows that in
> > the task_struct because a thread can have its capabilities masks changed by
> > another thread.  The shadowing is performed by update_current_cred() which is
> > invoked on entry to any system call that might need it.
> 
> OOC If we were to simply drop support for one process changing the
> capabilities of another, would we need this patch?

Umm...  It would become simpler (which is a damn good thing - less PITA
with update_current_cred), but it would be still needed.

FWIW, dropping that support would be a Good Thing(tm), as far as I'm
concerned.  _Why_ do we want that, anyway, and how much userland code
is able to cope with that in sane way?
