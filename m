Return-Path: <linux-kernel-owner+w=401wt.eu-S1761889AbYB2W1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761889AbYB2W1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761222AbYB2W1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:27:37 -0500
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:33655 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761835AbYB2W1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:27:36 -0500
X-YMail-OSG: VyOFl7AVM1k_dafaWU6b5z2zPseBv.pM8QjJ4sS1PR7IhcRvgkhSCumDZvBKU9LxVdsZgGV0nw--
X-RocketYMMF: rancidfat
Date: Fri, 29 Feb 2008 14:27:31 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Dave Quigley <dpquigl@tycho.nsa.gov>, casey@schaufler-ca.com
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Christoph Hellwig <hch@infradead.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204318831.2715.119.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <47870.32208.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:

> 
> ...
> > Yes, I can see that having a specific interface reduces the
> > documentation required, and simplifies it as well. Unfortunately,
> > given the way that a secctx is defined for either SELinux or
> > Smack, and the fact that the relationships between secctx values
> > are defined independently on the server and client* it does not
> > appear that the interoperability issue has been addressed, or
> > even really acknowleged with the proposed scheme. Yes, the issue
> > of label translation has been acknowleged, but it appears to me
> > that a day one solution is required for the scheme to be useful.
> 
> I completely disagree here. The Linux development model isn't to code
> the entire thing throw it over a wall and then deal with the collateral
> damage. This first version assumes a heterogenous environment and from
> what we see so far that seems to be the common usecase for this
> technology. A prototype implementation is already done for label
> translations and it does need to be outlined in the RFC (Which I've
> already started doing). However it is not necessary for an initial
> release. The translation engine allows you to plug in an arbitrary
> module to support whatever LSM you are going to use so this end of the
> architecture is agnostic to the format that is going to be used on the
> wire. For now that format is just a secctx which assumes the LSM running
> on both ends is the same.

It assumes more than that. It assumes that a secctx will be
interpreted exactly the same way on both the client and the server.
On an old style MLS machine, where the label was encoded in a
data structure, this was usually a reasonable assumption, but
even then not always. Given that there is no reason to expect that
the policy on the server will match that on the client it looks
to me like you've got a day one exposure. It doesn't matter that
the LSM is the same on both ends, that's one of Trond's arguements
that I've just accepted. You have no reason to expect
interoperability even with SELinux on both ends unless you can
somehow make statements about the relative values of the secctx
on the two machines. This applies to Smack just as strongly as
it does to SELinux, so it appears the scheme is flawwed in general,
not just in the SELinux case.

I hope that's clear and specific enough. Let me know if I'm
missing something.


> Once the basics are refined and we can use it
> as a base we will keep adding more functionality (process label
> transport, better change notification, server side policy enforcement,
> translation mappings.) 
> 
> This is just a tiny fraction of what James outlined in the requirements
> document. So, one step at a time lest we trip over imaginary stones.

The iteritive development model has it's advantages.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
