Return-Path: <linux-kernel-owner+w=401wt.eu-S940387AbXHMMvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940387AbXHMMvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942307AbXHMHjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:39:04 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:46705 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S942297AbXHMHi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:38:59 -0400
Message-ID: <386990734.21206@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Mon, 13 Aug 2007 15:38:53 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Moore <paul.moore@hp.com>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Vance <cvance@nai.com>, Wayne Salamon <wsalamon@nai.com>,
       James Morris <jmorris@redhat.com>, dgoeddel@trustedcs.com
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070813073853.GA5262@mail.ustc.edu.cn>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@epoch.ncsc.mil>, Chris Vance <cvance@nai.com>,
	Wayne Salamon <wsalamon@nai.com>, James Morris <jmorris@redhat.com>,
	dgoeddel@trustedcs.com
References: <20070812141905.4ee423b9@the-village.bc.nu> <386927758.14086@ustc.edu.cn> <20070812161744.200d4252@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812161744.200d4252@the-village.bc.nu>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 04:17:44PM +0100, Alan Cox wrote:
> Try this (it compiles but isnt tested). Its a weekend here, the sun is
> shining, the beach is a short walk, and I have more interesting things to
> do right now 8)

Have a nice day~~~ It works!

> --- linux.vanilla-2.6.23rc1-mm1/mm/mmap.c	2007-07-26 15:02:58.000000000 +0100
> +++ linux-2.6.23rc1-mm1/mm/mmap.c	2007-08-12 13:53:22.000000000 +0100
> @@ -2058,7 +2058,7 @@
>  	if (__vma && __vma->vm_start < vma->vm_end)
>  		return -ENOMEM;
>  	if ((vma->vm_flags & VM_ACCOUNT) &&
> -	     security_vm_enough_memory(vma_pages(vma)))
> +	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
>  		return -ENOMEM;
>  	vma_link(mm, vma, prev, rb_link, rb_parent);
>  	return 0;

Sorry, I overlooked this chunk in int insert_vm_struct(mm, vma), hehe.

