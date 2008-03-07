Return-Path: <linux-kernel-owner+w=401wt.eu-S1765417AbYCGTzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765417AbYCGTzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762087AbYCGTzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:55:06 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:55385 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761592AbYCGTzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:55:05 -0500
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Greg KH <greg@kroah.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com
In-Reply-To: <20080307183052.GB3898@sergelap.austin.ibm.com>
References: <20080307173542.GA2552@sergelap.austin.ibm.com>
	 <757539.74589.qm@web36608.mail.mud.yahoo.com>
	 <20080307183052.GB3898@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 07 Mar 2008 14:46:12 -0500
Message-Id: <1204919172.1397.541.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-07 at 12:30 -0600, Serge E. Hallyn wrote:
> Quoting Casey Schaufler (casey@schaufler-ca.com):
> > 
> > --- "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> > 
> > > ...
> > > 
> > > Until user namespaces are complete, selinux seems the only good solution
> > > to offer isolation.
> > 
> > Smack does it better and cheaper. (Unless you define good==selinux)
> > (insert smiley)
> 
> Ah, thanks - I hadn't looked into it, but yes IIUC smack should
> definately work.  I'll have to give that a shot.

Not if you want to confine uid 0.  smack doesn't control capabilities,
even the ones used to override it.

So you'd have to at least configure your per-process bset and file caps
rather carefully.  And even then you have to watch out for things with
CAP_MAC* or CAP_SETPCAP.
 
> (A basic selinux policy module to isolate a container was pretty simple,
> but providing finer-grained intra-container access seems to take some
> changes to the base refpolicy.  I've been waiting a few weeks to find
> time to work on that.)

-- 
Stephen Smalley
National Security Agency

