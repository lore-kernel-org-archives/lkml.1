Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbXF1PO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbXF1PO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXF1POq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:14:46 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:31288 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755363AbXF1POo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:14:44 -0400
X-YMail-OSG: BrNwvYgVM1mukAJgcBWimbvfHmAndwFdFOdZsnvzOymw7EYcYvmSqaz5oZrP9MuQZq1VXsOvdQ--
X-RocketYMMF: rancidfat
Date: Thu, 28 Jun 2007 08:14:43 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: implement-file-posix-capabilities.patch
To: Andrew Morgan <morgan@kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <468352EC.2080704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <924812.95310.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morgan <morgan@kernel.org> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge E. Hallyn wrote:
> >> Does that explain it?
> > 
> > Yes, thanks, but then it still could come in handy to have fE be a full
> > bitset, so the application gets some eff caps automatically, while
> > others it has to manually set...
> 
> [We touched on this a number of emails back.]
> 
> If an application is capability aware, it can manipulate its own
> capabilities and should have fE=0.
> 
> If an application is not capability aware, it needs to have *all* of its
> capabilities enabled at exec() time. Otherwise, it won't work.

The intent of the fE vector in the POSIX draft is that those capabilities
are set on exec (lower vectors permitting). There are cases where it
does make sense to raise just some (e.g. ping). 

> The only reason for having an fE bitmap is to allow a capability-aware
> program (you really trust to do its privileged operations carefully) to
> be lazy and get some of its capabilities raised for free. Perhaps you
> can clarify why this is a desirable thing? :-)

No, it's to allow you to grant a subset of the available capabilities
to a program that is not aware of capabilities. You can give "date"
the capability to reset the clock without giving it the capability
to remove other people's files without changing the code or running
it setuid.


Casey Schaufler
casey@schaufler-ca.com
