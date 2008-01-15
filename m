Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYAOSK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYAOSK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYAOSKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:10:19 -0500
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:47375 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750852AbYAOSKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:10:17 -0500
X-YMail-OSG: MSeQVaoVM1mg6Re08tISyPs9YLHQ4uwoyziN2mykv3S8U21PmVSQ7Gjn8Pehs.BIO_p_XlyGQw--
X-RocketYMMF: rancidfat
Date: Tue, 15 Jan 2008 10:10:12 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: David Howells <dhowells@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, Daniel J Walsh <dwalsh@redhat.com>,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
In-Reply-To: <32507.1200412997@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <286481.40953.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > >  (3) Check that the kernel may create files as a particular secid (this
> > >      could be specified indirectly by specifying an inode, which would
> > >      hide the secid inside the LSM).
> > 
> > I don't think this check is on the kernel per se but rather the ability
> > of the daemon to nominate a secid for use on files created later by the
> > kernel module.
> 
> Hmmm...  At the moment the cachefiles module works out for itself what the
> file label should be by looking at the root directory it was given and
> assuming the label on that is what it's going to be using.  Are you
> suggesting
> this should be specified directly instead by the daemon?

Oh my. While there will be cases where the label of the file
will match the label of the containing directory, and in fact
for most label based LSMs that will usually be the case, you
certainly can't count on it. The only place that you can find
the correct label for a file with any confidence in from the
xattr (assuming the LSM uses xattrs) on the file itself. I can
imaging an LSM for which it would make sense to derive the
label from the root directory, but I know Smack isn't one of
them, and I don't think that SELinux is either, although I
would defer a definitive answer on that to Stephen.


Casey Schaufler
casey@schaufler-ca.com
