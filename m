Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXLJXrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXLJXrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbXLJXrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:47:03 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:44419 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751039AbXLJXrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:47:01 -0500
X-YMail-OSG: bQyxZX4VM1k6QfX5WU91QdMlsRsUTDzZ6dItSFO.Ldj0jwXsQpRo44CQ7TSdoqHosfmyfhQe3A--
X-RocketYMMF: rancidfat
Date: Mon, 10 Dec 2007 15:46:59 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: David Howells <dhowells@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
In-Reply-To: <25965.1197329769@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <899818.54251.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > From a config file whose pathname would be provided by libselinux (ala
> > the way in which dbusd imports contexts), or directly as a context
> > returned by a libselinux function.
> 
> That sounds too SELinux specific.  How do I do it so that it works for any
> LSM?
> 
> Is linking against libselinux is a viable option if it's not available under
> all LSM models?  Is it available under all LSM models?  Perhaps Casey can
> answer this one.

Linking against libselinux is not now, nor will it ever be, a viable
option. There's just too much sophistication contained in libselinux
for us simple folk to deal with.

> > > I use to do that, but someone objected...  Possibly Karl MacMillan.
> > 
> > Yes, but I think I disagreed then too.
> 
> So, who's right?

Me! (smiley inserted here, for those in need)

> > It doesn't fit with how other users of security_kernel_act_as() will
> > likely want to work (they will want to just set the context to a
> > specified value, whether one obtained from the client or from some local
> > source), nor with how type transitions normally work (exec, with the
> > program type as the second type field).  I think it will just cause
> > confusion and subtle breakage.
> 
> It's causing me lots of confusion as it is.  I have been / am being told by
> different people to do different things just in dealing with SELinux, and
> various people are raising extra requirements or restrictions beyond that.
> There doesn't seem to be a consensus.
> 
> It sounds like the best option is just to have the kernel nick the userspace
> daemon's security context and use that as is, and junk all the restrictions
> on
> what the daemon can do so that the kernel isn't too restricted.

That would be consistant with the (perhaps archaic now) behavior
of nfsd on Unix, which did nothing but "lend it's credential" to the
underlying kernel code. I think it's a rational approach, although I
expect that in may have troubles under SELinux.


Casey Schaufler
casey@schaufler-ca.com
