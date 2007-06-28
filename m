Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbXF1PjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbXF1PjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbXF1Pi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:38:58 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46751 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbXF1Pi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:38:56 -0400
Date: Thu, 28 Jun 2007 10:38:44 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andrew Morgan <morgan@kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
Message-ID: <20070628153844.GA1977@sergelap.austin.ibm.com>
References: <468352EC.2080704@kernel.org> <924812.95310.qm@web36611.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924812.95310.qm@web36611.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> 
> --- Andrew Morgan <morgan@kernel.org> wrote:
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Serge E. Hallyn wrote:
> > >> Does that explain it?
> > > 
> > > Yes, thanks, but then it still could come in handy to have fE be a full
> > > bitset, so the application gets some eff caps automatically, while
> > > others it has to manually set...
> > 
> > [We touched on this a number of emails back.]
> > 
> > If an application is capability aware, it can manipulate its own
> > capabilities and should have fE=0.
> > 
> > If an application is not capability aware, it needs to have *all* of its
> > capabilities enabled at exec() time. Otherwise, it won't work.
> 
> The intent of the fE vector in the POSIX draft is that those capabilities
> are set on exec (lower vectors permitting). There are cases where it
> does make sense to raise just some (e.g. ping). 
> 
> > The only reason for having an fE bitmap is to allow a capability-aware
> > program (you really trust to do its privileged operations carefully) to
> > be lazy and get some of its capabilities raised for free. Perhaps you
> > can clarify why this is a desirable thing? :-)
> 
> No, it's to allow you to grant a subset of the available capabilities
> to a program that is not aware of capabilities. You can give "date"
> the capability to reset the clock without giving it the capability
> to remove other people's files without changing the code or running
> it setuid.

Would there be a difference between that and setting either fI or fP
(depending on your intent) to those caps, and setting fE=1 in Andrew's
scheme?

thanks,
-serge
