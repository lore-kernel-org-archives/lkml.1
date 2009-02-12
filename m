Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbZBLWcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbZBLWcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 17:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBLWby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 17:31:54 -0500
Received: from tundra.namei.org ([65.99.196.166]:2781 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbZBLWbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 17:31:53 -0500
Date: Fri, 13 Feb 2009 09:31:04 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Mimi Zohar <zohar@us.ibm.com>, akpm <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH -next] security/audit/ima: fix build error
In-Reply-To: <20090212095414.733dd248.randy.dunlap@oracle.com>
Message-ID: <alpine.LRH.1.10.0902130930460.24108@tundra.namei.org>
References: <20090210194121.80256b72.sfr@canb.auug.org.au> <4991DBA0.1000008@oracle.com> <20090211094050.47c4828d.sfr@canb.auug.org.au> <OFF3345B15.9471295A-ON8525755A.00024CFE-8525755A.0002C8E8@us.ibm.com> <20090212095414.733dd248.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009, Randy Dunlap wrote:

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

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


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
> 

-- 
James Morris
<jmorris@namei.org>
