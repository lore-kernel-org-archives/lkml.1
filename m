Return-Path: <linux-kernel-owner+w=401wt.eu-S1765170AbYDOVeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765170AbYDOVeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYDOVeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:34:08 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34981 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbYDOVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:34:07 -0400
Date: Tue, 15 Apr 2008 16:34:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/2] eCryptfs: Introduce device handle for userspace
	daemon communications
Message-ID: <20080415213402.GA6446@sergelap.austin.ibm.com>
References: <20080415202313.GM4627@localhost.austin.ibm.com> <20080415140453.a45a15b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415140453.a45a15b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Tue, 15 Apr 2008 15:23:13 -0500
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> 
> > Functions to facilitate reading and writing to the eCryptfs
> > miscellaneous device handle. This will replace the netlink interface
> > as the preferred mechanism for communicating with the userspace
> > eCryptfs daemon.
> > 
> > Each user has his own daemon, which registers itself by opening the
> > eCryptfs device handle. Only one daemon per euid may be registered at
> > any given time. The eCryptfs module sends a message to a daemon by
> > adding its message to the daemon's outgoing message queue. The daemon
> > reads the device handle to get the oldest message off the queue.
> > 
> > Incoming messages from the userspace daemon are immediately
> > handled. If the message is a response, then the corresponding process
> > that is blocked waiting for the response is awakened.
> > 
> 
> This is a drastic change, but the changelog doesn't tell us why it is being
> made!
> 
> > ...
> > +	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid);
> > +	if (daemon->pid != current->pid) {
> > +	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid);
> > +	BUG_ON(current->euid != daemon->euid);
> > +	BUG_ON(current->pid != daemon->pid);
> 
> This code uses pids and uids all over the place.  Will it operate correctly
> in a containerised environment?

Thanks Andrew.

Mike, the pid_t definately needs to be replaced with a struct pid.

As for the euid, it'd be best if you also compared the user_namespace *
to make sure we support one ecryptfs deamon per user namespace.

thanks,
-serge
