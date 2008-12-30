Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYL3Wgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYL3Wgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 17:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYL3Wg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 17:36:27 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:34071 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYL3WgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 17:36:25 -0500
Subject: RE: Pull request for FS-Cache, including NFS patches
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Muntz, Daniel" <Dan.Muntz@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Bernd Schubert <bernd.schubert@fastmail.fm>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, steved@redhat.com, dhowells@redhat.com,
       linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       rwheeler@redhat.com
In-Reply-To: <7A24DF798E223B4C9864E8F92E8C93EC01AAFE66@SACMVEXC1-PRD.hq.netapp.com>
References: <7A24DF798E223B4C9864E8F92E8C93EC01AAFE66@SACMVEXC1-PRD.hq.netapp.com>
Content-Type: text/plain
Date: Tue, 30 Dec 2008 17:36:08 -0500
Message-Id: <1230676568.11508.21.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 36682D6DA9C2AD91867E5BB9F943FC486438E4E9
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 310 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-30 at 14:15 -0800, Muntz, Daniel wrote:
> >> As for security, look at what MIT had to do to prevent local disk 
> >> caching from breaking the security guarantees of AFS.
> >
> >See what David has added to the LSM code to provide the same guarantees
> for cachefs...
> >
> >Trond
> 
> Unless it (at least) leverages TPM, the issues I had in mind can't
> really be addressed in code.  One requirement is to prevent a local root
> user from accessing fs information without appropriate permissions.
> This leads to unwieldly requirements such as allowing only one user on a
> machine at a time, blowing away the cache on logout, validating (e.g.,
> refreshing) the kernel on each boot, etc.  Sure, some applications won't
> care, but you're also potentially opening holes that users may not
> consider.

You can't prevent a local root user from accessing cached data: that's
true with or without cachefs. root can typically access the data
using /dev/kmem, swap, intercepting tty traffic, spoofing user creds,...
If root can't be trusted, then find another machine.

The worry is rather that privileged daemons may be tricked into
revealing said data to unprivileged users, or that unprivileged users
may attempt to read data from files to which they have no rights using
the cachefs itself. That is a problem that is addressable by means of
LSM, and is what David has attempted to solve.

  Trond

