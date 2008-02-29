Return-Path: <linux-kernel-owner+w=401wt.eu-S933968AbYB2VIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbYB2VIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761767AbYB2VH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:07:59 -0500
Received: from web36608.mail.mud.yahoo.com ([209.191.85.25]:38887 "HELO
	web36608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933762AbYB2VH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:07:57 -0500
X-YMail-OSG: RZc1izwVM1lD2WCM4Ko_eTZAOveqOKiOoMzj26RYRLKuWDfpJcqituwKA4QMrp8SZxhk7FsKgg--
X-RocketYMMF: rancidfat
Date: Fri, 29 Feb 2008 13:07:55 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Trond Myklebust <trond.myklebust@fys.uio.no>, casey@schaufler-ca.com
Cc: Christoph Hellwig <hch@infradead.org>,
       Dave Quigley <dpquigl@tycho.nsa.gov>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204314629.7274.33.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <951672.28092.qm@web36608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Fri, 2008-02-29 at 10:52 -0800, Casey Schaufler wrote:
> > So it sounds as if for an xattr protocol to be viable it would first
> > require that xattr semantics be generally accepted (POSIX definition
> > would suffice), that there be multiple implementations (Linux and Irix
> > could suffice should Irix still be around when POSIX is done), and
> > that there be a perceived need beyond that of the Lunitic Fringe
> > Security Community.
> 
> The problem isn't that of supporting the naive user xattr model: we can
> almost do that within the existing 'named attribute' model of NFSv4. The
> problem is that of supporting the arbitrary "security metadata" that are
> allowed to have side-effects on the system behaviour, and that we appear
> to have thought was a good idea to overload onto the xattr interface.

Hum. Security metadata was one of the justifications for the
original implementation of the xattr interface for XFS at SGI.
The implementation was intended to be generic and allow for
storage of data that impacts system behavior. No, it is not
overloading at all, it is really supposed to be used that way.
That's how it works on CXFS, which I know is still proprietary,
but which could become an open peer of NFS someday.

> In the case of maclabels, where the "side-effect" is to describe and
> enable extra access control rules, then you have the potential for
> setting people up with a major interoperability problem. Using a
> dedicated interface for it instead of overloading a Linux-style xattr
> interface allows you to limit the scope of the documentation problem
> that you would otherwise have.

Yes, I can see that having a specific interface reduces the
documentation required, and simplifies it as well. Unfortunately,
given the way that a secctx is defined for either SELinux or
Smack, and the fact that the relationships between secctx values
are defined independently on the server and client* it does not
appear that the interoperability issue has been addressed, or
even really acknowleged with the proposed scheme. Yes, the issue
of label translation has been acknowleged, but it appears to me
that a day one solution is required for the scheme to be useful.

So I suggest, again from a position of possible ignorance, that
the proposed scheme suffers from some of the same interoperability
and specification issues that a name/value pair scheme does, with
the only real improvement being that the name part is hard coded.
Perhaps that is sufficient improvement to justify the loss of
generality, but I personally wouldn't think so.

-----
* Identical SELinux policy or Smack rule specifications are not
  necessaily sufficient to ensure label transparency.


Casey Schaufler
casey@schaufler-ca.com
