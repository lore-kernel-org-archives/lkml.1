Return-Path: <linux-kernel-owner+w=401wt.eu-S1761442AbYCAAJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761442AbYCAAJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 19:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbYCAAJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 19:09:22 -0500
Received: from pat.uio.no ([129.240.10.15]:40098 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbYCAAJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 19:09:21 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: casey@schaufler-ca.com
Cc: Christoph Hellwig <hch@infradead.org>,
       Dave Quigley <dpquigl@tycho.nsa.gov>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <951672.28092.qm@web36608.mail.mud.yahoo.com>
References: <951672.28092.qm@web36608.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 16:09:06 -0800
Message-Id: <1204330146.8237.24.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: DCEB39F45155D4A5ED60517E27E40AC4174AD1EC
X-UiO-SR-test: 7895943E8349CFEDD29684FC80D607BECE5F0A29
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 39 total 7162845 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 13:07 -0800, Casey Schaufler wrote:
> --- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > On Fri, 2008-02-29 at 10:52 -0800, Casey Schaufler wrote:
> > > So it sounds as if for an xattr protocol to be viable it would first
> > > require that xattr semantics be generally accepted (POSIX definition
> > > would suffice), that there be multiple implementations (Linux and Irix
> > > could suffice should Irix still be around when POSIX is done), and
> > > that there be a perceived need beyond that of the Lunitic Fringe
> > > Security Community.
> > 
> > The problem isn't that of supporting the naive user xattr model: we can
> > almost do that within the existing 'named attribute' model of NFSv4. The
> > problem is that of supporting the arbitrary "security metadata" that are
> > allowed to have side-effects on the system behaviour, and that we appear
> > to have thought was a good idea to overload onto the xattr interface.
> 
> Hum. Security metadata was one of the justifications for the
> original implementation of the xattr interface for XFS at SGI.
> The implementation was intended to be generic and allow for
> storage of data that impacts system behavior. No, it is not
> overloading at all, it is really supposed to be used that way.
> That's how it works on CXFS, which I know is still proprietary,
> but which could become an open peer of NFS someday.

Historical accidents change nothing to my argument. I still don't like
to be confusing user xattrs (which is a _storage_ issue) and the
security metadata (part of a _control_ protocol).

Nor do I see a compelling need to repeat any design mistakes that CXFS
might have made in this area...

> Yes, I can see that having a specific interface reduces the
> documentation required, and simplifies it as well. Unfortunately,
> given the way that a secctx is defined for either SELinux or
> Smack, and the fact that the relationships between secctx values
> are defined independently on the server and client* it does not
> appear that the interoperability issue has been addressed, or
> even really acknowleged with the proposed scheme. Yes, the issue
> of label translation has been acknowleged, but it appears to me
> that a day one solution is required for the scheme to be useful.

What would your expectation be for a SMACK-based client, if it mounts
from a server that turns out to be running with an SELinux security
model, or vice versa?

  Trond

