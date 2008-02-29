Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbYB2WkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbYB2WkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760317AbYB2Wjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:39:48 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:57668 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759605AbYB2Wjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:39:47 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Christoph Hellwig <hch@infradead.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <47870.32208.qm@web36615.mail.mud.yahoo.com>
References: <47870.32208.qm@web36615.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 17:15:05 -0500
Message-Id: <1204323305.2715.134.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 14:27 -0800, Casey Schaufler wrote:
> --- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:
> 
> > 
> > ...
> > > Yes, I can see that having a specific interface reduces the
> > > documentation required, and simplifies it as well. Unfortunately,
> > > given the way that a secctx is defined for either SELinux or
> > > Smack, and the fact that the relationships between secctx values
> > > are defined independently on the server and client* it does not
> > > appear that the interoperability issue has been addressed, or
> > > even really acknowleged with the proposed scheme. Yes, the issue
> > > of label translation has been acknowleged, but it appears to me
> > > that a day one solution is required for the scheme to be useful.
> > 
> > I completely disagree here. The Linux development model isn't to code
> > the entire thing throw it over a wall and then deal with the collateral
> > damage. This first version assumes a heterogenous environment and from
> > what we see so far that seems to be the common usecase for this
> > technology. A prototype implementation is already done for label
> > translations and it does need to be outlined in the RFC (Which I've
> > already started doing). However it is not necessary for an initial
> > release. The translation engine allows you to plug in an arbitrary
> > module to support whatever LSM you are going to use so this end of the
> > architecture is agnostic to the format that is going to be used on the
> > wire. For now that format is just a secctx which assumes the LSM running
> > on both ends is the same.
> 
> It assumes more than that. It assumes that a secctx will be
> interpreted exactly the same way on both the client and the server.
> On an old style MLS machine, where the label was encoded in a
> data structure, this was usually a reasonable assumption, but
> even then not always. Given that there is no reason to expect that
> the policy on the server will match that on the client it looks
> to me like you've got a day one exposure. It doesn't matter that
> the LSM is the same on both ends, that's one of Trond's arguements
> that I've just accepted. You have no reason to expect
> interoperability even with SELinux on both ends unless you can
> somehow make statements about the relative values of the secctx
> on the two machines. This applies to Smack just as strongly as
> it does to SELinux, so it appears the scheme is flawwed in general,
> not just in the SELinux case.

Actually we can expect interoperability with SELinux on both ends. With
policy being the same on both ends it is completely valid to export a
secctx which is a user readable text representation of a label and be
able to use it on another selinux machine with the same policy. If I
have a RHEL4 and RHEL 5 box with different policies then it is the job
of the translation daemon to say I've gotten this label from this doi do
I have a mapping for it. If yes translate it into my doi. If not reject
it. This property is really no different from a user or group and I
don't see anyone suggesting we start storing those in xattrs instead of
recommended attrs.

You need to give me a specific example of why if I have policy A on both
ends on an SELinux box that a secctx isn't the same on both boxes. 

> 
> I hope that's clear and specific enough. Let me know if I'm
> missing something.
> 
> 
> > Once the basics are refined and we can use it
> > as a base we will keep adding more functionality (process label
> > transport, better change notification, server side policy enforcement,
> > translation mappings.) 
> > 
> > This is just a tiny fraction of what James outlined in the requirements
> > document. So, one step at a time lest we trip over imaginary stones.
> 
> The iteritive development model has it's advantages.
> 
> Thank you.
> 
> 
> Casey Schaufler
> casey@schaufler-ca.com

