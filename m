Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYCMJ0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYCMJ0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbYCMJ0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:26:32 -0400
Received: from namei.org ([69.55.235.186]:60862 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750783AbYCMJ0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:26:31 -0400
Date: Thu, 13 Mar 2008 20:25:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       Greg KH <greg@kroah.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
In-Reply-To: <20080313032749.GA13258@sergelap.austin.ibm.com>
Message-ID: <Xine.LNX.4.64.0803132022530.6358@us.intercode.com.au>
References: <20080313032749.GA13258@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Serge E. Hallyn wrote:

> +#ifdef CONFIG_SECURITY
> +static struct security_operations devcgroup_security_ops = {
> +	.inode_mknod = 			devcgroup_inode_mknod,
> +	.inode_permission = 		devcgroup_inode_permission,
> +
> +	.ptrace =			cap_ptrace,
> +	.capget =			cap_capget,
> +	.capset_check =			cap_capset_check,
> +	.capset_set =			cap_capset_set,
> +	.capable =			cap_capable,
> +	.settime =			cap_settime,
> +	.netlink_send =			cap_netlink_send,
> +	.netlink_recv =			cap_netlink_recv,
> +
> +	.bprm_apply_creds =		cap_bprm_apply_creds,
> +	.bprm_set_security =		cap_bprm_set_security,
> +	.bprm_secureexec =		cap_bprm_secureexec,
> +
> +	.inode_setxattr =		cap_inode_setxattr,
> +	.inode_removexattr =		cap_inode_removexattr,
> +	.inode_need_killpriv =		cap_inode_need_killpriv,
> +	.inode_killpriv =		cap_inode_killpriv,
> +
> +	.task_kill =			cap_task_kill,
> +	.task_setscheduler =		cap_task_setscheduler,
> +	.task_setioprio =		cap_task_setioprio,
> +	.task_setnice =			cap_task_setnice,
> +	.task_post_setuid =		cap_task_post_setuid,
> +	.task_prctl =                   cap_task_prctl,
> +	.task_reparent_to_init =	cap_task_reparent_to_init,
> +
> +	.syslog =                       cap_syslog,
> +
> +	.vm_enough_memory =             cap_vm_enough_memory,
> +};

For lower overall complexity, why not just extend the capability LSM to 
include the devcgroup_ perms if CONFIG_CGROUP_DEV ?



- James
-- 
James Morris
<jmorris@namei.org>
