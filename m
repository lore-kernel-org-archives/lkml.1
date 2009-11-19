Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZKSU1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZKSU1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 15:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZKSU1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 15:27:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbZKSU1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:27:40 -0500
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: drop SECURITY_FILE_CAPABILITIES?
Date: Thu, 19 Nov 2009 15:26:15 -0500
User-Agent: KMail/1.12.2 (Linux/2.6.30.9-96.fc11.x86_64; KDE/4.3.2; x86_64; ; )
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
References: <20091110140739.GA15534@us.ibm.com> <200911181433.30967.sgrubb@redhat.com> <551280e50911190735u210e2c60xc944c333b122d22d@mail.gmail.com>
In-Reply-To: <551280e50911190735u210e2c60xc944c333b122d22d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191526.15345.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 November 2009 10:35:12 am Andrew G. Morgan wrote:
> How about this change?
> 
> @@ -169,8 +169,11 @@ SYSCALL_DEFINE2(capget, cap_user_header_
>        kernel_cap_t pE, pI, pP;
> 
>        ret = cap_validate_magic(header, &tocopy);
> -       if (ret != 0)
> +       if ((ret != 0) || (dataptr == NULL)) {
> +               if ((ret == -EINVAL) && (dataptr == NULL))
> +                       return 0;
>                return ret;
> +       }
> 
>        if (get_user(pid, &header->pid))
>                return -EFAULT;
> 
> ? This is a slightly modified version of what you posted before.
> Specifically, in the case that the user guessed a compatible version
> this NULL call will succeed and not EFAULT.

Sure. Looks good to me.

Thanks,
-Steve
