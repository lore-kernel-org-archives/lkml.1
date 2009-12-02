Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZLBOhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZLBOhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZLBOhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:37:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbZLBOhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:37:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
References: <1259128503-28276-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>
Subject: Re: [PATCH] NOMMU: use copy_*_user_page() in access_process_vm()
Date: Wed, 02 Dec 2009 14:36:34 +0000
Message-ID: <16225.1259764594@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> -			len -= copy_to_user((void *) addr, buf, len);
> +			copy_to_user_page(vma, NULL, NULL,
> +					  (void *) addr, buf, len);
>  		else if (!write && vma->vm_flags & VM_MAYREAD)
> -			len -= copy_from_user(buf, (void *) addr, len);
> +			copy_from_user_page(vma, NULL, NULL,
> +					    buf, (void *) addr, len);

Hmmm...  With this, len isn't updated anymore, and so it alters the return
value of access_process_vm(), and means ptrace_readdata() won't now return
-EIO under some circumstances where it used to.  I'm not sure that matters,
though.

David
