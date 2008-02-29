Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbYB2Swj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbYB2Swj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760813AbYB2Sw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:52:28 -0500
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:21524 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759691AbYB2Sw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:52:26 -0500
X-YMail-OSG: qm3jiJsVM1kG3u0MIqX3VJuLvZT9YWVdWfrzAGGg63U_bdUwaxmAYw8nS7NYE_VdX2mZwsOw1w--
X-RocketYMMF: rancidfat
Date: Fri, 29 Feb 2008 10:52:21 -0800 (PST)
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
In-Reply-To: <1204309719.10512.36.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <850338.40421.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Fri, 2008-02-29 at 09:46 -0800, Casey Schaufler wrote:
> > > There is no room for extensions that allow clients+servers to establish
> > > arbitrary private protocols.
> > 
> > I think that I understand that you believe that, what I
> > don't understand is why you believe that. Is it an artifact
> > of the locking protocol that only worked about half the
> > time, and then in a half donkied way?
> > 
> > I'm not trying to be an obstructionist idiot here, even if
> > that's how it may appear. I have my pet solution, I really
> > don't see the problem with it, and it looks to me like the
> > arguements against it are either so obvious I'm missing them
> > (does happen) or based on dogmas I don't subscribe to.
> > 
> > Thank you for helping me (and maybe some others) understand
> > the issues we're up against so that I (we) can address issues
> > better in the future.
> 
> Two of the main reasons for NFS's success as a protocol are the facts
> that it is (more or less) standardized, while remaining (again more or
> less) back-end agnostic. I can take pretty much any client from any one
> vendor and any server from any other vendor, and make them work
> together.
> 
> The reason why this works is mainly because the protocol has built upon
> a consensus assumption of POSIX filesystem semantics on the servers
> (hence, BTW, the pain when the IETF requested that we add
> Microsoft-compatible semantics to NFSv4 as a precondition for making it
> a standard).

Ok, and since there is no POSIX file system semantic defined
for extended attributes it's really tough to create a protocol
specification that implements the POSIX file system semantics.

> If you look back at the NFS extensions that failed, and fell by the
> road, then they tend to be the semi-private non-posix extensions
> (typically ACL semantics, xattrs/named attributes, "secure NFS",...)
> which break the underlying assumption that I can mix and match clients
> and servers.

And without a definition of what behavior should be on the file system
you can't really say what the behavior should be in the network
protocol in the case where one end does not support the behavior.

> <rhetorical>Does that mean that we shouldn't provide extensions
> protocols for doing these things?</rhetorical> Of course not... The
> point about such extensions is that they need to be agreed upon by the
> NFS community/stakeholders, in much the same way that any changes to the
> kernel need to be agreed upon by the Linux community/stakeholders.

And a precursor to this is that the community agree on the underlying
file system semantics. Just because xattrs work on Irix and Linux
doesn't make them standard, and it would be rough going to claim
that the existance of those two implementations indicates stakeholder
acceptance.

> Adding a mechanism that allows subsets of clients/servers to set up
> private protocols circumvents that consensus process, and are therefore
> a bad thing, and should be avoided. That would be engaging in the exact
> same "embrace, extend and extinguish" tactics for which we keep
> criticizing certain other monopolists.

So it sounds as if for an xattr protocol to be viable it would first
require that xattr semantics be generally accepted (POSIX definition
would suffice), that there be multiple implementations (Linux and Irix
could suffice should Irix still be around when POSIX is done), and
that there be a perceived need beyond that of the Lunitic Fringe
Security Community.

> This should be a no-brainer...

I hope that I've wrapped my brain around your rationale.
If I have missed the point again, don't hesitate to correct me.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
