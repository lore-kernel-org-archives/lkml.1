Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbYCGVcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbYCGVcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760686AbYCGVcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:32:20 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34029 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760724AbYCGVcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:32:20 -0500
Date: Fri, 7 Mar 2008 15:32:20 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Greg KH <greg@kroah.com>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
Message-ID: <20080307213220.GA12334@sergelap.austin.ibm.com>
References: <1204919172.1397.541.camel@moss-spartans.epoch.ncsc.mil> <26315.23145.qm@web36606.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26315.23145.qm@web36606.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> 
> --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > 
> > On Fri, 2008-03-07 at 12:30 -0600, Serge E. Hallyn wrote:
> > > Quoting Casey Schaufler (casey@schaufler-ca.com):
> > > > 
> > > > --- "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> > > > 
> > > > > ...
> > > > > 
> > > > > Until user namespaces are complete, selinux seems the only good
> > solution
> > > > > to offer isolation.
> > > > 
> > > > Smack does it better and cheaper. (Unless you define good==selinux)
> > > > (insert smiley)
> > > 
> > > Ah, thanks - I hadn't looked into it, but yes IIUC smack should
> > > definately work.  I'll have to give that a shot.
> > 
> > Not if you want to confine uid 0.  smack doesn't control capabilities,
> > even the ones used to override it.
> > 
> > So you'd have to at least configure your per-process bset and file caps
> > rather carefully.  And even then you have to watch out for things with
> > CAP_MAC* or CAP_SETPCAP.
> 
> Shrug. As if getting 800,000 lines of policy definition
> for a thousand applications completely correct is going to be easier.

Folks, as I get time I will try with both :)

I suspect the CAP_MAC_ADMIN will mean containers won't be able to do any
policy updates without an update to smack to do a CAP_NS_OVERRIDE type
of thing.  For SELinux I've got my hopes on the userspace policy daemon,
but first (my next step atm) I need to get the namespace thing going
(vserver1.root_t etc).

-serge
