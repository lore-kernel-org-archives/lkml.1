Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYBERwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYBERwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYBERw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:52:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:46849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbYBERw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:52:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JSJxFFukv8Fa75FrbhI6Q/76dwOYZ4fLBV4PYnvGXMIVtYb97j6yYUFlgBuoBV5XbUbR5Atmmmu1R2Iy9NMzWrtOnNugEhvrMcER9G5x2OCghKBqllisxrhRAyN6egT9LnNk7EM0KqEakj8I3w2zHVV7fNlFDV6+rMQbzfyue08=
Message-ID: <cadfc0e40802050952p519dae9co7ecec84bb67231dd@mail.gmail.com>
Date: Tue, 5 Feb 2008 11:52:25 -0600
From: "Xavier Toth" <txtoth@gmail.com>
To: "Eamon Walsh" <ewalsh@tycho.nsa.gov>
Subject: Re: [PATCH] selinux: make mls_compute_sid always polyinstantiate
Cc: "SELinux List" <selinux@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       "James Morris" <jmorris@namei.org>,
       "Stephen Smalley" <sds@tycho.nsa.gov>
In-Reply-To: <4798F57C.8090300@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4798F57C.8090300@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this in rawhide, if not when will it be?

On Thu, Jan 24, 2008 at 2:30 PM, Eamon Walsh <ewalsh@tycho.nsa.gov> wrote:
> This patch removes the requirement that the new and related object types
>  differ in order to polyinstantiate by MLS level.  This allows MLS
>  polyinstantiation to occur in the absence of explicit type_member rules
>  or when the type has not changed.
>
>  Potential users of this support include pam_namespace.so (directory
>  polyinstantiation) and the SELinux X support (property polyinstantiation).
>
>  Signed-off-by: Eamon Walsh <ewalsh@tycho.nsa.gov>
>  ---
>
>   mls.c |   11 ++---------
>   1 file changed, 2 insertions(+), 9 deletions(-)
>
>
>  diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
>  index fb5d70a..3bbcb53 100644
>  --- a/security/selinux/ss/mls.c
>  +++ b/security/selinux/ss/mls.c
>  @@ -537,15 +537,8 @@ int mls_compute_sid(struct context *scontext,
>                         /* Use the process effective MLS attributes. */
>                         return mls_context_cpy_low(newcontext, scontext);
>         case AVTAB_MEMBER:
>  -               /* Only polyinstantiate the MLS attributes if
>  -                  the type is being polyinstantiated */
>  -               if (newcontext->type != tcontext->type) {
>  -                       /* Use the process effective MLS attributes. */
>  -                       return mls_context_cpy_low(newcontext, scontext);
>  -               } else {
>  -                       /* Use the related object MLS attributes. */
>  -                       return mls_context_cpy(newcontext, tcontext);
>  -               }
>  +               /* Use the process effective MLS attributes. */
>  +               return mls_context_cpy_low(newcontext, scontext);
>         default:
>                 return -EINVAL;
>         }
>
>
>
>  --
>  Eamon Walsh <ewalsh@tycho.nsa.gov>
>  National Security Agency
>
>
>  --
>  This message was distributed to subscribers of the selinux mailing list.
>  If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
>  the words "unsubscribe selinux" without quotes as the message.
>
