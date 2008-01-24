Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbYAXUoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbYAXUoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757817AbYAXUgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:36:31 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:60014 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbYAXUga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:36:30 -0500
Subject: Re: [PATCH] selinux: make mls_compute_sid always polyinstantiate
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Eamon Walsh <ewalsh@tycho.nsa.gov>
Cc: SELinux List <selinux@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
In-Reply-To: <4798F57C.8090300@tycho.nsa.gov>
References: <4798F57C.8090300@tycho.nsa.gov>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 24 Jan 2008 15:36:18 -0500
Message-Id: <1201206978.21288.139.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 15:30 -0500, Eamon Walsh wrote:
> This patch removes the requirement that the new and related object types 
> differ in order to polyinstantiate by MLS level.  This allows MLS 
> polyinstantiation to occur in the absence of explicit type_member rules 
> or when the type has not changed.
> 
> Potential users of this support include pam_namespace.so (directory 
> polyinstantiation) and the SELinux X support (property polyinstantiation).
> 
> Signed-off-by: Eamon Walsh <ewalsh@tycho.nsa.gov>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
> 
>  mls.c |   11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)

(nit:  use diffstat -p1 in the future)

> 
> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
> index fb5d70a..3bbcb53 100644
> --- a/security/selinux/ss/mls.c
> +++ b/security/selinux/ss/mls.c
> @@ -537,15 +537,8 @@ int mls_compute_sid(struct context *scontext,
>  			/* Use the process effective MLS attributes. */
>  			return mls_context_cpy_low(newcontext, scontext);
>  	case AVTAB_MEMBER:
> -		/* Only polyinstantiate the MLS attributes if
> -		   the type is being polyinstantiated */
> -		if (newcontext->type != tcontext->type) {
> -			/* Use the process effective MLS attributes. */
> -			return mls_context_cpy_low(newcontext, scontext);
> -		} else {
> -			/* Use the related object MLS attributes. */
> -			return mls_context_cpy(newcontext, tcontext);
> -		}
> +		/* Use the process effective MLS attributes. */
> +		return mls_context_cpy_low(newcontext, scontext);
>  	default:
>  		return -EINVAL;
>  	}
> 
> 
> 
-- 
Stephen Smalley
National Security Agency

