Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbXLKUlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbXLKUlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXLKUk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:40:56 -0500
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:31873 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751126AbXLKUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:40:55 -0500
X-YMail-OSG: Uun.5R8VM1lz_YPkhaY94vqPM4SwKVBwUG3vmSzYQEe1EIJe_81eNjwy222Gh4FsXmn4ryKoQQ--
X-RocketYMMF: rancidfat
Date: Tue, 11 Dec 2007 12:40:54 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <1197402998.28006.95.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <81940.57362.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> 
> > I am much more concerned with the interfaces used to pass the
> > information into the kernel. I would expect that to be LSM
> > independent, not a call into libselinux that resolves into a
> > selinuxfs operation, or it's netlink equivilant. It would be
> > unfortunate if the userland/kernel interface became an obstacle
> > to cachefiles being adopted.
> 
> That wasn't the issue.  The interface to the cachefiles module would
> just consist of cachefilesd writing a string label to some pseudo file
> tell cachefiles what label to apply as the acting label for operations
> performed by cachefiles.  Which isn't SELinux-specific at all.

Calm down. Just checking.

> David was asking though how cachefilesd (the userspace agent) would
> obtain such a label to use.  And that may very well be LSM-specific, and
> as there is no LSM userspace API, it makes sense for him to invoke a
> libselinux function at present.  If a liblsm is later created and
> provides a common front-end API (internally dlopen'ing the right shared
> library based on some configuration, whether libselinux or libsmack or
> whatever), then cachefilesd can instead call the liblsm interface, but
> that doesn't exist today.

I am certainly not in favor of adding such complexity.
I suggest that cachefilesd get the context it wants using
whatever scheme works. I think there should be a cachefiles
specific (LSM independent) scheme for getting it into the
kernel, and a LSM hooks for setting it, if that's what he
really wants to do.



Casey Schaufler
casey@schaufler-ca.com
