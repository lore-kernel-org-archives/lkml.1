Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYCMOiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYCMOiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYCMOiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:38:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57051 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYCMOiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:38:07 -0400
Date: Thu, 13 Mar 2008 09:38:03 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Message-ID: <20080313143803.GA11265@sergelap.austin.ibm.com>
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au> <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
> 
> > That does make for a simpler implementation at this point, however if
> > any other such LSMs come along (as Casey seemed to think they would) the
> > end result could end up being horrible spaghetti code of dependencies
> > and interrelated configs.
> 
> That can be addressed as the need arises.  A basic tenet of kernel 
> development is to avoid speculative infrastructure.

True, but while this change simplifies the code a bit, the semantics
seem more muddled - devcg will be enforcing when CONFIG_CGROUP_DEV=y
and:

	SECURITY=n or
	rootplug is enabled
	capabilities is enabled
	smack is enabled
	selinux+capabilities is enabled

It will not be enforcing when
	dummy is loaded
	only selinux (and not capabilities) is loaded

If that's ok with people then I'm fine with it.  I suppose it should be
explained in the CONFIG_CGROUP_DEV help section, which it isn't in this
version I'm about to set.  Patch hitting the wire in a minute.

thanks,
-serge

> > But OTOH we went years with no such changes, so that's probably not a
> > particularly practical concern unless someone can cite specific upcoming
> > examples.  So if noone objects I'll try that approach.
> 
> -- 
> James Morris
> <jmorris@namei.org>
