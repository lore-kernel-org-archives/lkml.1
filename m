Return-Path: <linux-kernel-owner+w=401wt.eu-S1161329AbXBGQME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161329AbXBGQME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161357AbXBGQMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:12:03 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:56581 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030632AbXBGQMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:12:00 -0500
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
In-Reply-To: <20070207154332.GF10574@sequoia.sous-sol.org>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
	 <200702051813.26958.agruen@suse.de>
	 <1170766539.12293.370.camel@moss-spartans.epoch.ncsc.mil>
	 <200702070055.10856.agruen@suse.de>
	 <20070207154332.GF10574@sequoia.sous-sol.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 07 Feb 2007 11:06:43 -0500
Message-Id: <1170864403.11912.43.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 07:43 -0800, Chris Wright wrote:
> * Andreas Gruenbacher (agruen@suse.de) wrote:
> > Reiserfs currently only marks the ".reiserfs_priv" directory as private, but 
> > not the files below it -- how about the attached patch to fix that?
> 
> I don't think that's right.  Look at ->create or ->lookup.  Both of those
> properly set the private flag.  This patch looks like a step backwards,
> sprinkling the init in so many places.

Yes, I thought that this was already covered by the existing inheritance
of the private flag from the parent directory.

On a separate note, I believe that the current problem with using
reiserfs and selinux is just that reiserfs hasn't been updated to call
security_inode_init_security() and set the security xattr when creating
a new file; see ext3 or jfs for an example.  But I don't know of anyone
using reiserfs with selinux presently.

-- 
Stephen Smalley
National Security Agency

