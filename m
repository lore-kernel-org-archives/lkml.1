Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZBQXyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZBQXyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZBQXyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:54:22 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:12219 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZBQXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:54:21 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [PATCH] SMACK smacklabel : apply &MASK to IP inserted in /smack/netlabel
Date: Tue, 17 Feb 2009 18:54:17 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27-gentoo-r8; KDE/4.2.0; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <499B178B.9090601@numericable.fr> <499B1ECF.2020809@numericable.fr>
In-Reply-To: <499B1ECF.2020809@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171854.17203.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009 03:32:15 pm etienne wrote:
> ----
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 8e42800..5717150 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -765,6 +765,7 @@ static ssize_t smk_write_netlbladdr(struct file *file,
> const char __user *buf, mask.s_addr |= bebits;
>                 bebits <<= 1;
>         }
> +       newname.sin_addr.s_addr &= mask.s_addr;
>         /*
>          * Only allow one writer at a time. Writes should be
>          * quite rare and small in any case.

If you do this you can simplify some of the code in smack_host_label() by 
removing the code which applies the mask to the stored addresses when 
comparing addresses.  There may be other places as well.

-- 
paul moore
linux @ hp

