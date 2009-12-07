Return-Path: <linux-kernel-owner+w=401wt.eu-S935061AbZLGNcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935061AbZLGNcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934940AbZLGNcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:32:22 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59164 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934777AbZLGNcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:32:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=M4N7D40MFia+bYRbT11CyFa/XccN9kE8srPgYg2i/CJG7p5np4zAVovL/JEmsB83rq
         cecj1OFPKalvM3ibVEgh9NlGPkgztIetdyfJ3O6dwglFcxtpE6Sk7db3sbKcKzcRzqeD
         /ZvmChndMVEhx0evq5OWhEdFJk7Xgc4UEGFUg=
MIME-Version: 1.0
In-Reply-To: <20091203085127.4370.1737.sendpatchset@localhost.localdomain>
References: <20091203085127.4370.1737.sendpatchset@localhost.localdomain>
Date: Mon, 7 Dec 2009 15:32:26 +0200
Message-ID: <b263e5900912070532i6ab63c36o48030a191c091dd5@mail.gmail.com>
Subject: Re: [Patch] selinux: remove a useless return
From: Dan Carpenter <error27.lkml@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/09, Amerigo Wang <amwang@redhat.com> wrote:
> The last return is unreachable, remove the 'return'
> in default, let it fall through.
>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Eric Paris <eparis@parisplace.org>
>
> ---
>
> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
> index b5407f1..718823d 100644
> --- a/security/selinux/ss/mls.c
> +++ b/security/selinux/ss/mls.c
> @@ -542,7 +542,7 @@ int mls_compute_sid(struct context *scontext,
>  		/* Use the process effective MLS attributes. */
>  		return mls_context_cpy_low(newcontext, scontext);
>  	default:
> -		return -EINVAL;
> +		/* Fallthrough */
>  	}
>  	return -EINVAL;
>  }

I don't think this compiles.  GCC doesn't let you end a switch block
with a label.

I also have sent the selinux people a patch that didn't compile by
mistake.  Afterward I wrote this script so hopefully I won't mess up
again.

#!/bin/bash -e

files=$(grep +++ /home/dcarpenter/var/mail/postponed-msgs | cut -f 1 |
cut -b 5-)
for file in $files ; do
	file=${file/devel\//}
	file=${file/new\//}
	kchecker $file
	if which sparse | grep -q sparse ; then
		kchecker --sparse $file
	fi
done


You will have to change the path names.  Hm....  Also you will have to
get the kchecker script from the smatch_data/ directory of smatch
(http://repo.or.cz/w/smatch.git).

regards,
dan carpenter
