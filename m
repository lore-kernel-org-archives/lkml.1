Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZHRMKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZHRMKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZHRMKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:10:46 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:33857 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZHRMKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:10:45 -0400
Subject: Re: [PATCH] Security/sysfs: v2 - Enable security xattrs to be set
 on sysfs files, directories, and symlinks.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
In-Reply-To: <4A8A2616.8020809@schaufler-ca.com>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>
	 <4A861291.1030404@schaufler-ca.com> <m1tz09j00q.fsf@fess.ebiederm.org>
	 <4A864008.50907@schaufler-ca.com> <m1my61sjie.fsf@fess.ebiederm.org>
	 <4A8A2616.8020809@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 18 Aug 2009 08:14:20 -0400
Message-Id: <1250597660.3629.204.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 20:55 -0700, Casey Schaufler wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Another approach to limited xattr support in sysfs.
> 
> I tried to listen to the objections to a linked list representation
> and I think that I understand that there isn't really any interest
> in supporting xattrs for real, only for those maintained by LSMs.
> I also looked carefully into the claims that memory usage is
> critical and that the code I had before was duplicating effort.
> 
> This version lets the surrounding code do as much of the work as
> possible. Unlike the initial proposal for sysfs xattrs, it does not
> introduce any new LSM hooks, it uses hooks that already exist. It
> does not support any attributes on its own, it only provides for
> the attribute advertised by security_inode_listsecurity(). It could
> easily be used by other filesystems to provide the same LSM xattr
> support. It could also be extended to do the list based support for
> arbitrary xattrs without too much effort.
> 
> Probably the oddest bit is that the inode_getsecurity hooks need to
> check to see if they are getting called before the inode is instantiated
> and return -ENODATA in that event. It would be possible to do a
> filesystem specific check instead, but this way provides for generally
> correct behavior at small cost.
> 
> This has been tested with Smack, but not SELinux. I think that
> SELinux will work correctly, but it could be that a labeling
> behavior that is different than the "usual" instantiation labeling
> is actually desired. That would be an easy change.
> 
> As always, let me know if I missed something obvious or if there's a
> fatal flaw in the scheme.

The point of the David's patch was to provide a way to save the security
xattr in the backing data structure for sysfs entries when an attribute
value is set from userspace so that the value can be preserved if the
inode is evicted from memory and later re-instantiated.  AFAICS, your
patch completely misses the problem.  How about we just go back to
David's patch?

-- 
Stephen Smalley
National Security Agency

