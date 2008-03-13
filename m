Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbYCMNSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbYCMNSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 09:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYCMNSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 09:18:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53866 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbYCMNSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:18:24 -0400
Date: Thu, 13 Mar 2008 08:18:18 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Message-ID: <20080313131818.GA9771@sergelap.austin.ibm.com>
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Wed, 12 Mar 2008, Serge E. Hallyn wrote:
> 
> > +#ifdef CONFIG_SECURITY
> > +static struct security_operations devcgroup_security_ops = {
> > +	.inode_mknod = 			devcgroup_inode_mknod,
> > +	.inode_permission = 		devcgroup_inode_permission,
> > +
> > +	.ptrace =			cap_ptrace,
> > +	.capget =			cap_capget,
> > +	.capset_check =			cap_capset_check,
> > +	.capset_set =			cap_capset_set,
> > +	.capable =			cap_capable,
> > +	.settime =			cap_settime,
> > +	.netlink_send =			cap_netlink_send,
> > +	.netlink_recv =			cap_netlink_recv,
> > +
> > +	.bprm_apply_creds =		cap_bprm_apply_creds,
> > +	.bprm_set_security =		cap_bprm_set_security,
> > +	.bprm_secureexec =		cap_bprm_secureexec,
> > +
> > +	.inode_setxattr =		cap_inode_setxattr,
> > +	.inode_removexattr =		cap_inode_removexattr,
> > +	.inode_need_killpriv =		cap_inode_need_killpriv,
> > +	.inode_killpriv =		cap_inode_killpriv,
> > +
> > +	.task_kill =			cap_task_kill,
> > +	.task_setscheduler =		cap_task_setscheduler,
> > +	.task_setioprio =		cap_task_setioprio,
> > +	.task_setnice =			cap_task_setnice,
> > +	.task_post_setuid =		cap_task_post_setuid,
> > +	.task_prctl =                   cap_task_prctl,
> > +	.task_reparent_to_init =	cap_task_reparent_to_init,
> > +
> > +	.syslog =                       cap_syslog,
> > +
> > +	.vm_enough_memory =             cap_vm_enough_memory,
> > +};
> 
> For lower overall complexity, why not just extend the capability LSM to 
> include the devcgroup_ perms if CONFIG_CGROUP_DEV ?

That does make for a simpler implementation at this point, however if
any other such LSMs come along (as Casey seemed to think they would) the
end result could end up being horrible spaghetti code of dependencies
and interrelated configs.

But OTOH we went years with no such changes, so that's probably not a
particularly practical concern unless someone can cite specific upcoming
examples.  So if noone objects I'll try that approach.

thanks,
-serge
