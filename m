Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYBKSul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYBKSul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYBKSub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:50:31 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:64399 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbYBKSu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:50:29 -0500
Subject: Re: [PATCH 07/37] Security: De-embed task security record from
	task and use refcounting
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, Trond.Myklebust@netapp.com,
       chuck.lever@oracle.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
In-Reply-To: <28534.1202751036@redhat.com>
References: <Xine.LNX.4.64.0802112156030.27028@us.intercode.com.au>
	 <20080208165156.15902.62457.stgit@warthog.procyon.org.uk>
	 <20080208165235.15902.8174.stgit@warthog.procyon.org.uk>
	 <28534.1202751036@redhat.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 11 Feb 2008 13:48:44 -0500
Message-Id: <1202755724.24250.75.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 17:30 +0000, David Howells wrote:
> James Morris <jmorris@namei.org> wrote:
> 
> > > Remove the temporarily embedded task security record from task_struct.
> > > Instead it is made to dangle from the task_struct::sec and
> > > task_struct::act_as pointers with references counted for each.
> > 
> > ...
> > 
> > These patches are kind of huge.
> 
> Yeah, I know.  The problem is that each patch must compile and run.  They
> can't be split up without violating that unfortunately.
> 
> > Why manually copy these fields after a kmemdup?
> 
> Fair point.  Fixed.
> 
> > What about the task backpointer? (i.e. tsec2->task)
> 
> The problem is that there can't be one with this patch as the task_security
> struct and the LSM security data attached to it may outlive the task it points
> back to.
> 
> It seems that the backpointer can be dispensed with.  Nothing particularly
> seems to use it.  Do you know the reason for its existence?

Looks unused now.
Similarly for some of the other security structs.
Only inode, superblock, and sock back pointers still seem to be in use.

-- 
Stephen Smalley
National Security Agency

