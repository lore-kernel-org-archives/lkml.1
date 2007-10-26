Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbXJZBOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbXJZBOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 21:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXJZBO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 21:14:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10841 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbXJZBO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 21:14:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VMfcrcW64DMYIcrHC72QwfHpWmx6sVR+3ELKPrxCECcYT2M2/E5g3a/uq9UJBNw8g
	SDkSCCeSrdm5QLUMpufbw==
Message-ID: <6599ad830710251814s39b05559wb782b9aeab40f828@mail.gmail.com>
Date: Thu, 25 Oct 2007 18:14:19 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC] cgroup simplify space stripping
Cc: "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20071024173621.24359.1372.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024173621.24359.1372.sendpatchset@jackhammer.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
> Simplify the space stripping code in cgroup file write.
>
> Signed-off-by: Paul Jackson <pj@sgi.com>

Acked-by: Paul Menage <menage@google.com>

>
> ---
>
> This patch applies after both:
>         Adrian Bunk's: [2.6 patch] kernel/cgroup.c: remove dead code
>         pj's: [PATCH] cgroup brace coding style fix
>
>  kernel/cgroup.c |   15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
>
> --- 2.6.23-mm1.orig/kernel/cgroup.c     2007-10-24 10:03:11.847801501 -0700
> +++ 2.6.23-mm1/kernel/cgroup.c  2007-10-24 10:29:08.355032464 -0700
> @@ -1327,6 +1327,7 @@ static ssize_t cgroup_common_file_write(
>                 goto out1;
>         }
>         buffer[nbytes] = 0;     /* nul-terminate */
> +       strstrip(buffer);       /* strip -just- trailing whitespace */
>
>         mutex_lock(&cgroup_mutex);
>
> @@ -1347,19 +1348,9 @@ static ssize_t cgroup_common_file_write(
>                         clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
>                 break;
>         case FILE_RELEASE_AGENT:
> -       {
> -               struct cgroupfs_root *root = cgrp->root;
> -               /* Strip trailing newline */
> -               if (nbytes && (buffer[nbytes-1] == '\n'))
> -                       buffer[nbytes-1] = 0;
> -               /* We never write anything other than '\0'
> -                * into the last char of release_agent_path,
> -                * so it always remains a NUL-terminated
> -                * string */
> -               strncpy(root->release_agent_path, buffer, nbytes);
> -               root->release_agent_path[nbytes] = 0;
> +               BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
> +               strcpy(cgrp->root->release_agent_path, buffer);
>                 break;
> -       }
>         default:
>                 retval = -EINVAL;
>                 goto out2;
>
> --
>                           I won't rest till it's the best ...
>                           Programmer, Linux Scalability
>                           Paul Jackson <pj@sgi.com> 1.650.933.1373
>
