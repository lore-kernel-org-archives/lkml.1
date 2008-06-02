Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYFBNZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYFBNZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYFBNY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:24:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887AbYFBNYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:24:54 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: Novell, SuSE Labs
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 01/15] security: pass path to inode_create
Date: Mon, 2 Jun 2008 15:24:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
References: <20080529134903.615127628@szeredi.hu> <200806021445.13831.agruen@suse.de> <20080602124906.GD8562@parisc-linux.org>
In-Reply-To: <20080602124906.GD8562@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021524.51597.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2008 14:49:06 Matthew Wilcox wrote:
> On Mon, Jun 02, 2008 at 02:45:10PM +0200, Andreas Gruenbacher wrote:
> > Without the vfsmount, when something is mounted in more than once place,
> > you cannot report which of the name aliases a process is accessing. This
> > is unacceptable; the logs would become unusable. With pathname-based, the
> > AppArmor and TOMOYO folks really mean pathname-based, not a hybrid
> > pathname / mount point model.
>
> audit_getname manages to do this.

You would assume, but no: audit_getname() grabs a reference to the pwd and the 
absolute or relative pathname. The vfs resolves this to a dentry, but there 
is no guarantee that the audit system will end up with the same pathname for 
reporting: the namespace may have changed arbitrarily in the meantime.

(I find it rather interesting that this is consistent enough for audit; in my 
opinion it isn't.)

On the other hand, AppArmor computes the path it uses for checking from the 
dentry/vfsmount atomically with respect to namespace changes, and so the path 
used for checking and reporting is always consistent (and it is guaranteed 
that the object has been reachable via this path at the time the path has 
been generated).

Andreas
