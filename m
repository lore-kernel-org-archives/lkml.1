Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbXF1P5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbXF1P5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbXF1P47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:56:59 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:46158 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756169AbXF1P46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:56:58 -0400
X-YMail-OSG: x2FhyR4VM1mMw9D3UO9Gw5mT7aZVmpYmLTie1EKaEK_gv0OK
X-RocketYMMF: rancidfat
Date: Thu, 28 Jun 2007 08:56:57 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: implement-file-posix-capabilities.patch
To: "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Andrew Morgan <morgan@kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070628153844.GA1977@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <325190.92239.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Casey Schaufler (casey@schaufler-ca.com):
> > 
> > --- Andrew Morgan <morgan@kernel.org> wrote:
> > 
> > > -----BEGIN PGP SIGNED MESSAGE-----
> > > Hash: SHA1
> > > 
> > > Serge E. Hallyn wrote:
> > > >> Does that explain it?
> > > > 
> > > > Yes, thanks, but then it still could come in handy to have fE be a full
> > > > bitset, so the application gets some eff caps automatically, while
> > > > others it has to manually set...
> > > 
> > > [We touched on this a number of emails back.]
> > > 
> > > If an application is capability aware, it can manipulate its own
> > > capabilities and should have fE=0.
> > > 
> > > If an application is not capability aware, it needs to have *all* of its
> > > capabilities enabled at exec() time. Otherwise, it won't work.
> > 
> > The intent of the fE vector in the POSIX draft is that those capabilities
> > are set on exec (lower vectors permitting). There are cases where it
> > does make sense to raise just some (e.g. ping). 
> > 
> > > The only reason for having an fE bitmap is to allow a capability-aware
> > > program (you really trust to do its privileged operations carefully) to
> > > be lazy and get some of its capabilities raised for free. Perhaps you
> > > can clarify why this is a desirable thing? :-)
> > 
> > No, it's to allow you to grant a subset of the available capabilities
> > to a program that is not aware of capabilities. You can give "date"
> > the capability to reset the clock without giving it the capability
> > to remove other people's files without changing the code or running
> > it setuid.
> 
> Would there be a difference between that and setting either fI or fP
> (depending on your intent) to those caps, and setting fE=1 in Andrew's
> scheme?

Arg, you're making me think. The POSIX group went through this,
let me see if I can reconstruct the logic.

The main issue is one if there being a possible case where you
have a capability ignorant program that you want to exec with
a different fP and fE. On first glance it seems that since the
program is capability ignorant it can't matter. But what if your
capability ignorant program exec's a capability aware program
to perform a helper function? You may well want the first program
to have a capability that it does not use in fP (but not fE)
to pass along to the helper program. True, you could probably
come up with a way to set the capabilities on the helper program
to account for this use, but there may be design and security
constraints that make doing so complicated. 



Casey Schaufler
casey@schaufler-ca.com
