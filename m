Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYCNN63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYCNN63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbYCNN6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:58:20 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50773 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbYCNN6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:58:20 -0400
Date: Fri, 14 Mar 2008 08:58:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Message-ID: <20080314135817.GE8744@sergelap.austin.ibm.com>
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au> <20080313131818.GA9771@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140049270.9059@us.intercode.com.au> <20080313143803.GA11265@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803140925410.30342@us.intercode.com.au> <20080313224616.GA9139@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803141046340.1545@us.intercode.com.au> <20080314014121.GA8320@sergelap.austin.ibm.com> <47DA4533.8030106@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA4533.8030106@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> Serge E. Hallyn wrote:
> > Quoting James Morris (jmorris@namei.org):
> >> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
> >>
> >>> Quoting James Morris (jmorris@namei.org):
> >>>> On Thu, 13 Mar 2008, Serge E. Hallyn wrote:
> >>>>
> >>>>> True, but while this change simplifies the code a bit, the semantics
> >>>>> seem more muddled - devcg will be enforcing when CONFIG_CGROUP_DEV=y
> >>>>> and:
> >>>>>
> >>>>> 	SECURITY=n or
> >>>>> 	rootplug is enabled
> >>>>> 	capabilities is enabled
> >>>>> 	smack is enabled
> >>>>> 	selinux+capabilities is enabled
> >>>> Well, this is how real systems are going to be deployed.
> >>> Sorry, do you mean with capabilities?
> >> Yes.
> >>
> >> All Fedora, RHEL, CentOS etc. ship with SELinux+capabilities.  I can't 
> >> imagine not enabling them on other kernels.
> >>
> >>>> It becomes confusing, IMHO, if you have to change which secondary LSM you 
> >>>> stack with SELinux to enable a cgroup feature.
> >>> So you're saying selinux without capabilities should still be able to
> >>> use dev_cgroup?  (Just making sure I understand right)
> >> Nope, SELinux always stacks with capabilities, so havng the cgroup hooks 
> >> in capabilities makes sense (rather than having us change the secondary 
> >> stacking LSM just to enable a feature).
> > 
> > Oh, ok.
> > 
> > Will let the patch stand until Pavel and Greg comment then.
> 
> Well, I saw your previous patch, that was implemented as just another
> LSM module and I liked it except for the LSM dependency.

James and Stephen agree with your LSM qualms.  I suppose we could add
cgroups next to the lsm hooks.  I suspect Paul Menage would complain
about that (Paul?), and I do think it's silly as they are security
questions, not group tracking questions, but if it's what people want
I can send out a new patch next week.

> Since this version can happily work w/o LSM, I like it too :)

In an earlier version I asked whether you had any experience with usual
# rules per container.  Do you have an idea?  Right now the whitelist is
a straight list we search through linearly.  If # rules is generally
tiny then I'm inclined to keep it that way...

thanks,
-serge
