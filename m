Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZBLSYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZBLSYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 13:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbZBLSYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 13:24:22 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56802 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757800AbZBLSYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 13:24:21 -0500
Subject: Re: [PATCH -next] security/audit/ima: fix build error
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mimi Zohar <zohar@us.ibm.com>, akpm <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
In-Reply-To: <20090212095414.733dd248.randy.dunlap@oracle.com>
References: <20090210194121.80256b72.sfr@canb.auug.org.au>
	 <4991DBA0.1000008@oracle.com>
	 <20090211094050.47c4828d.sfr@canb.auug.org.au>
	 <OFF3345B15.9471295A-ON8525755A.00024CFE-8525755A.0002C8E8@us.ibm.com>
	 <20090212095414.733dd248.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 13:24:18 -0500
Message-Id: <1234463058.3104.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 09:54 -0800, Randy Dunlap wrote:
> On Tue, 10 Feb 2009 19:30:24 -0500 Mimi Zohar wrote:
> 
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote on 02/10/2009 05:40:50 PM:
> > 
> > > Hi Randy,
> > > 
> > > On Tue, 10 Feb 2009 11:55:12 -0800 Randy Dunlap 
> > <randy.dunlap@oracle.com> wrote:
> > > >
> > > > Stephen Rothwell wrote:
> > > > > 
> > > > > Dropped trees (temporarily):
> > > > >    audit (difficult conflicts)
> > > > 
> > > > Maybe this is fixed by the dropped audit tree?
> > > 
> > > The audit tree is Al Viro's (cc'd).  But I *think* everything in it has
> > > been applied upstream.
> > > 
> > > > linux-next-20090210/security/integrity/ima/ima_policy.c:111: error: 
> > implicit
> > > declaration of function 'security_audit_rule_match'
> > > > linux-next-20090210/security/integrity/ima/ima_policy.c:230: error: 
> > implicit
> > > declaration of function 'security_audit_rule_init'
> > > > 
> > > > when
> > > > CONFIG_SECURITY=y
> > > > CONFIG_AUDIT=n
> > > > CONFIG_IMA=y
> > > > CONFIG_IMA_AUDIT=y
> > > 
> > > This looks more like a security subsystem than audit to me?
> > 
> > These are the IMA Kconfig rules:
> > CONFIG_IMA=y
> > CONFIG_IMA_MEASURE_PCR_IDX=10
> > CONFIG_IMA_AUDIT=y
> > CONFIG_IMA_LSM_RULES=y
> > 
> > CONFIG_IMA_LSM_RULES requires the audit subsystem.  The default
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > measurement policy is not defined terms of the LSM extended
> > attributes, and thus is not required.
> 
> 
> This config still fails to build in linux-next-20090212.  And the ^^^
> statement above may be correct, but it's not enforced in Kconfig, so let's
> do that, OK?

The patch looks good to me, but looking at the code,
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=blob_plain;f=mm/shmem.c;hb=168b70b72a78f289046823d810c29376e211a6de
it doesn't look like the previous patch was applied.

> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> IMA_LSM_RULES requires AUDIT.  This is automatic if SECURITY_SELINUX=y
> but not when SECURITY_SMACK=y (and SECURITY_SELINUX=n), so make the
> dependency explicit.  This fixes the following build error:
> 
> security/integrity/ima/ima_policy.c:111:error: implicit declaration of function 'security_audit_rule_match'
> security/integrity/ima/ima_policy.c:230:error: implicit declaration of function 'security_audit_rule_init'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>

> ---
>  security/integrity/ima/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20090212.orig/security/integrity/ima/Kconfig
> +++ linux-next-20090212/security/integrity/ima/Kconfig
> @@ -49,7 +49,7 @@ config IMA_AUDIT
> 
>  config IMA_LSM_RULES
>  	bool
> -	depends on IMA && (SECURITY_SELINUX || SECURITY_SMACK)
> +	depends on IMA && AUDIT && (SECURITY_SELINUX || SECURITY_SMACK)
>  	default y
>  	help
> -	  Disabling this option will disregard LSM based policy rules
> +	  Disabling this option will disregard LSM based policy rules.

