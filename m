Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0BSNry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 08:47:54 -0500
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:36518 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0BSNrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 08:47:52 -0500
Subject: Re: [PATCH] LSM: add static to security_ops variable
From: Stephen Smalley <sds@tycho.nsa.gov>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, eparis@parisplace.org,
       lsm <linux-security-module@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>
In-Reply-To: <628d1651002190340o59305986h738aec31ec5e6a84@mail.gmail.com>
References: <628d1651002070324w424012eanda9392db26331905@mail.gmail.com>
	 <1266332237.5252.48.camel@moss-pluto.epoch.ncsc.mil>
	 <628d1651002190340o59305986h738aec31ec5e6a84@mail.gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 19 Feb 2010 08:47:46 -0500
Message-Id: <1266587266.32011.6.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 19:40 +0800, wzt wzt wrote:
> I rewrite the patch, thx.

Patch description needs to be descriptive, e.g.:
"Enhance the security framework to support resetting the active security
module.  This eliminates the need for direct use of the security_ops
variable outside of security.c, so make security_ops static."

Subject line could be more descriptive too, and likely just use
security: as the prefix.

You also need a Signed-off-by line, with a real name.

Also, see the comments below.

> ---
>  include/linux/security.h |    2 ++
>  security/security.c      |    7 ++++++-
>  security/selinux/hooks.c |   14 ++------------
>  3 files changed, 10 insertions(+), 13 deletions(-)
> 

> diff --git a/security/security.c b/security/security.c
> index 122b748..3e4c4bc 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -26,7 +26,7 @@ static __initdata char chosen_lsm[SECURITY_NAME_MAX + 1] =
>  extern struct security_operations default_security_ops;
>  extern void security_fixup_ops(struct security_operations *ops);
> 
> -struct security_operations *security_ops;      /* Initialized to NULL */
> +static struct security_operations *security_ops;       /* Initialized
> to NULL */

You can drop the /* Initialized to NULL */ comment since it is now
static.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 9a2ee84..e9599fd 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -93,6 +93,7 @@
> 
>  extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
>  extern struct security_operations *security_ops;
> +extern struct security_operations default_security_ops;

We don't need this extern declaration.

The next obvious cleanup would be to make default_security_ops static.
That will require some code reorganization though - it is presently
defined in capability.c and manipulated by security.c.

-- 
Stephen Smalley
National Security Agency

