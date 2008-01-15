Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbYAOTQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbYAOTQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:16:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYAOTPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:15:53 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:53189 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYAOTPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:15:52 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <286481.40953.qm@web36613.mail.mud.yahoo.com>
References: <286481.40953.qm@web36613.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 15 Jan 2008 14:15:08 -0500
Message-Id: <1200424508.9669.63.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 10:10 -0800, Casey Schaufler wrote:
> --- David Howells <dhowells@redhat.com> wrote:
> 
> > Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > 
> > > >  (3) Check that the kernel may create files as a particular secid (this
> > > >      could be specified indirectly by specifying an inode, which would
> > > >      hide the secid inside the LSM).
> > > 
> > > I don't think this check is on the kernel per se but rather the ability
> > > of the daemon to nominate a secid for use on files created later by the
> > > kernel module.
> > 
> > Hmmm...  At the moment the cachefiles module works out for itself what the
> > file label should be by looking at the root directory it was given and
> > assuming the label on that is what it's going to be using.  Are you
> > suggesting
> > this should be specified directly instead by the daemon?
> 
> Oh my. While there will be cases where the label of the file
> will match the label of the containing directory, and in fact
> for most label based LSMs that will usually be the case, you
> certainly can't count on it. The only place that you can find
> the correct label for a file with any confidence in from the
> xattr (assuming the LSM uses xattrs) on the file itself. I can
> imaging an LSM for which it would make sense to derive the
> label from the root directory, but I know Smack isn't one of
> them, and I don't think that SELinux is either, although I
> would defer a definitive answer on that to Stephen.

The cache files are created by the cachefiles kernel module, not by the
userspace daemon, and the userspace daemon doesn't need to directly
read/write them at all (but I think it does need to be able to unlink
them?).  The userspace daemon merely identifies the directory where the
cache should live as part of configuring the cache when enabling it.

Hence, it is fine to use a fixed label for the cache files (systemhigh
in a MLS world), and to let the directory's label serve as the basis for
it.  Only the cachefiles kernel module directly reads and writes the
files.
 
-- 
Stephen Smalley
National Security Agency

