Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYCNFA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYCNFA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYCNFAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:00:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60591 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYCNFAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:00:13 -0400
Date: Thu, 13 Mar 2008 21:47:41 -0700
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Message-ID: <20080314044741.GB18077@kroah.com>
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au> <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au> <20080313143803.GA11265@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au> <20080313224616.GA9139@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au> <20080314014121.GA8320@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314014121.GA8320@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 08:41:21PM -0500, Serge E. Hallyn wrote:
> Quoting James Morris (jmorris@namei.org):
> > On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
> > 
> > > Quoting James Morris (jmorris@namei.org):
> > > > On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
> > > > 
> > > > > True, but while this change simplifies the code a bit, the semantics
> > > > > seem more muddled - devcg will be enforcing when CONFIG_CGROUP_DEV=y
> > > > > and:
> > > > > 
> > > > > 	SECURITY=n or
> > > > > 	rootplug is enabled
> > > > > 	capabilities is enabled
> > > > > 	smack is enabled
> > > > > 	selinux+capabilities is enabled
> > > > 
> > > > Well, this is how real systems are going to be deployed.
> > > 
> > > Sorry, do you mean with capabilities?
> > 
> > Yes.
> > 
> > All Fedora, RHEL, CentOS etc. ship with SELinux+capabilities.  I can't 
> > imagine not enabling them on other kernels.
> > 
> > > > It becomes confusing, IMHO, if you have to change which secondary LSM you 
> > > > stack with SELinux to enable a cgroup feature.
> > > 
> > > So you're saying selinux without capabilities should still be able to
> > > use dev_cgroup?  (Just making sure I understand right)
> > 
> > Nope, SELinux always stacks with capabilities, so havng the cgroup hooks 
> > in capabilities makes sense (rather than having us change the secondary 
> > stacking LSM just to enable a feature).
> 
> Oh, ok.
> 
> Will let the patch stand until Pavel and Greg comment then.

My main question was why was that file in the kernel/ directory?
Shouldn't that also be in the security/ directory?

And to be honest, I didn't really look at it at all other than the
diffstat to make sure you weren't messing with the kobj_map stuff
anymore :)

thanks,

greg k-h
