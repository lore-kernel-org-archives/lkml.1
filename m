Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYCNCv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYCNCv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYCNCvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:51:21 -0400
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:26151 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751859AbYCNCvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:51:20 -0400
X-YMail-OSG: OHu2JHkVM1lc8SbuwrlAV408ZNxBFD5o5Edfn6qaNOocmd3EiZJFuaajdm.3nld47A--
X-RocketYMMF: rancidfat
Date: Thu, 13 Mar 2008 19:51:19 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
To: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Greg KH <greg@kroah.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
In-Reply-To: <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <910788.93851.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- James Morris <jmorris@namei.org> wrote:

> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
> 
> > Quoting James Morris (jmorris@namei.org):
> > > On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
> > > 
> > > > True, but while this change simplifies the code a bit, the semantics
> > > > seem more muddled - devcg will be enforcing when CONFIG_CGROUP_DEV=y
> > > > and:
> > > > 
> > > > 	SECURITY=n or
> > > > 	rootplug is enabled
> > > > 	capabilities is enabled
> > > > 	smack is enabled
> > > > 	selinux+capabilities is enabled
> > > 
> > > Well, this is how real systems are going to be deployed.
> > 
> > Sorry, do you mean with capabilities?
> 
> Yes.
> 
> All Fedora, RHEL, CentOS etc. ship with SELinux+capabilities.  I can't 
> imagine not enabling them on other kernels.
> 
> > > It becomes confusing, IMHO, if you have to change which secondary LSM you
> 
> > > stack with SELinux to enable a cgroup feature.
> > 
> > So you're saying selinux without capabilities should still be able to
> > use dev_cgroup?  (Just making sure I understand right)
> 
> Nope, SELinux always stacks with capabilities, so havng the cgroup hooks 
> in capabilities makes sense (rather than having us change the secondary 
> stacking LSM just to enable a feature).

That's what I was getting at. When the next feature comes along
are we going to stuff it into capabilities, too? Maybe we'll
cram it into audit or CIPSO instead, but how long can this go on?
Eventually we need a mechanism that allows more or less general
mix-and-match, maybe with a few rules like "don't mix plaids and
stripes" to keep things sane or these lesser facilities have no
chance. Seems like we're still making LSM too hard to use.

Unless I take an aggressive approach to adding them to Smack.
Hmm, might be a way to make a buck or two that way.
(Only kidding)(Well, mostly only kidding)

And yes, I understand that there are still those about who
don't like LSM in any form, much less in a useful one.


Casey Schaufler
casey@schaufler-ca.com
