Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYAXVC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYAXVC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbYAXVCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:02:40 -0500
Received: from exchange.columbia.tresys.com ([216.250.243.126]:44679 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757126AbYAXVCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:02:40 -0500
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2008 16:02:39 EST
Message-ID: <4798F91B.3030509@manicmethod.com>
Date: Thu, 24 Jan 2008 15:46:19 -0500
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Eamon Walsh <ewalsh@tycho.nsa.gov>
CC: SELinux List <selinux@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] selinux: make mls_compute_sid always polyinstantiate
References: <4798F57C.8090300@tycho.nsa.gov>
In-Reply-To: <4798F57C.8090300@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jan 2008 20:46:23.0901 (UTC) FILETIME=[2EA4B4D0:01C85ECA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eamon Walsh wrote:
> This patch removes the requirement that the new and related object 
> types differ in order to polyinstantiate by MLS level.  This allows 
> MLS polyinstantiation to occur in the absence of explicit type_member 
> rules or when the type has not changed.
>
> Potential users of this support include pam_namespace.so (directory 
> polyinstantiation) and the SELinux X support (property 
> polyinstantiation).
>
> Signed-off-by: Eamon Walsh <ewalsh@tycho.nsa.gov>
> ---
>
> mls.c |   11 ++---------
> 1 file changed, 2 insertions(+), 9 deletions(-)
>
>
> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
> index fb5d70a..3bbcb53 100644
> --- a/security/selinux/ss/mls.c
> +++ b/security/selinux/ss/mls.c
> @@ -537,15 +537,8 @@ int mls_compute_sid(struct context *scontext,
>             /* Use the process effective MLS attributes. */
>             return mls_context_cpy_low(newcontext, scontext);
>     case AVTAB_MEMBER:
> -        /* Only polyinstantiate the MLS attributes if
> -           the type is being polyinstantiated */
> -        if (newcontext->type != tcontext->type) {
> -            /* Use the process effective MLS attributes. */
> -            return mls_context_cpy_low(newcontext, scontext);
> -        } else {
> -            /* Use the related object MLS attributes. */
> -            return mls_context_cpy(newcontext, tcontext);
> -        }
> +        /* Use the process effective MLS attributes. */
> +        return mls_context_cpy_low(newcontext, scontext);
>     default:
>         return -EINVAL;
>     }

Should there be a patch to update mls.c in libsepol as well? I hope we 
are keeping the kss and uss in sync.

