Return-Path: <linux-kernel-owner+w=401wt.eu-S932255AbYB2SaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbYB2SaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757080AbYB2S3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:29:53 -0500
Received: from pat.uio.no ([129.240.10.15]:43945 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbYB2S3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:29:51 -0500
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
In-Reply-To: <856298.92497.qm@web36605.mail.mud.yahoo.com>
References: <856298.92497.qm@web36605.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 10:28:39 -0800
Message-Id: <1204309719.10512.36.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 5FBB9FBD67A16DECF7FF93D480FF80595E986F2E
X-UiO-SR-test: 0C6E007704C78D1B2AFAA4AEAD3D234BA8173685
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 217 total 7160902 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 09:46 -0800, Casey Schaufler wrote:
> > There is no room for extensions that allow clients+servers to establish
> > arbitrary private protocols.
> 
> I think that I understand that you believe that, what I
> don't understand is why you believe that. Is it an artifact
> of the locking protocol that only worked about half the
> time, and then in a half donkied way?
> 
> I'm not trying to be an obstructionist idiot here, even if
> that's how it may appear. I have my pet solution, I really
> don't see the problem with it, and it looks to me like the
> arguements against it are either so obvious I'm missing them
> (does happen) or based on dogmas I don't subscribe to.
> 
> Thank you for helping me (and maybe some others) understand
> the issues we're up against so that I (we) can address issues
> better in the future.

Two of the main reasons for NFS's success as a protocol are the facts
that it is (more or less) standardized, while remaining (again more or
less) back-end agnostic. I can take pretty much any client from any one
vendor and any server from any other vendor, and make them work
together.

The reason why this works is mainly because the protocol has built upon
a consensus assumption of POSIX filesystem semantics on the servers
(hence, BTW, the pain when the IETF requested that we add
Microsoft-compatible semantics to NFSv4 as a precondition for making it
a standard).

If you look back at the NFS extensions that failed, and fell by the
road, then they tend to be the semi-private non-posix extensions
(typically ACL semantics, xattrs/named attributes, "secure NFS",...)
which break the underlying assumption that I can mix and match clients
and servers.

<rhetorical>Does that mean that we shouldn't provide extensions
protocols for doing these things?</rhetorical> Of course not... The
point about such extensions is that they need to be agreed upon by the
NFS community/stakeholders, in much the same way that any changes to the
kernel need to be agreed upon by the Linux community/stakeholders.

Adding a mechanism that allows subsets of clients/servers to set up
private protocols circumvents that consensus process, and are therefore
a bad thing, and should be avoided. That would be engaging in the exact
same "embrace, extend and extinguish" tactics for which we keep
criticizing certain other monopolists.

This should be a no-brainer...

Trond

