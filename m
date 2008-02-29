Return-Path: <linux-kernel-owner+w=401wt.eu-S933614AbYB2TvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614AbYB2TvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbYB2Tuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:50:54 -0500
Received: from pat.uio.no ([129.240.10.15]:39748 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbYB2Tuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:50:52 -0500
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
In-Reply-To: <850338.40421.qm@web36605.mail.mud.yahoo.com>
References: <850338.40421.qm@web36605.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 11:50:28 -0800
Message-Id: <1204314629.7274.33.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 46191232DFF31B3FA2652197EBEF0F55B75430FB
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 349 total 7161498 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-29 at 10:52 -0800, Casey Schaufler wrote:
> So it sounds as if for an xattr protocol to be viable it would first
> require that xattr semantics be generally accepted (POSIX definition
> would suffice), that there be multiple implementations (Linux and Irix
> could suffice should Irix still be around when POSIX is done), and
> that there be a perceived need beyond that of the Lunitic Fringe
> Security Community.

The problem isn't that of supporting the naive user xattr model: we can
almost do that within the existing 'named attribute' model of NFSv4. The
problem is that of supporting the arbitrary "security metadata" that are
allowed to have side-effects on the system behaviour, and that we appear
to have thought was a good idea to overload onto the xattr interface.

In the case of maclabels, where the "side-effect" is to describe and
enable extra access control rules, then you have the potential for
setting people up with a major interoperability problem. Using a
dedicated interface for it instead of overloading a Linux-style xattr
interface allows you to limit the scope of the documentation problem
that you would otherwise have.

Trond

