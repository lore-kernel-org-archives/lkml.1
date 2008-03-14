Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYCNOFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYCNOFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbYCNOF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:05:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49398 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548AbYCNOF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:05:28 -0400
Date: Fri, 14 Mar 2008 09:05:23 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Message-ID: <20080314140523.GG8744@sergelap.austin.ibm.com>
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <6599ad830803140216k1a04ce4ej4779bf10ec6ef4f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830803140216k1a04ce4ej4779bf10ec6ef4f9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Wed, Mar 12, 2008 at 8:27 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> >  While composing this with the ns_cgroup may seem logical, it is not
> >  the right thing to do, because updates to /cg/cg1/devcg.deny are
> >  not reflected in /cg/cg1/cg2/devcg.allow.
> 
> Maybe you should follow up the tree to ensure that all parent groups
> have access to the device too? Or alternatively, cache the results of
> this lookup whenever permissions for a device change?

Yes, I considered that.  Alternatively additions to a parent cgroup's
.deny could be propagated to all its descendents (but not additions to
the .allow).

I've noted this as something to add to the next version.

> >  A task may only be moved to another devcgroup if it is moving to
> >  a direct descendent of its current devcgroup.
> 
> What's the rationale for that?

To prevent it escaping to laxer device permissions, which of course only
makes sense if we do what you recommend above :)

> >  CAP_NS_OVERRIDE is defined as the capability needed to cross namespaces.
> >  A task needs both CAP_NS_OVERRIDE and CAP_SYS_ADMIN to create a new
> >  devcgroup, update a devcgroup's access, or move a task to a new
> >  devcgroup.
> 
> But this isn't necessarily crossing namespaces. It could be used for
> device control in the same namespace (e.g. allowing a job to access a
> raw disk for its data storage rather than going through the
> filesystem).

Yeah it should be renamed.  I want to use the same cap which we would
use for user namespaces though.  CAP_NS_CONT(ainer)?  Even though there
really is no such thing as a 'container'.  But that would tie together
any such privileges for cgroups and namespaces.

thanks,
-serge
