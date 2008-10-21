Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYJUW72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYJUW72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYJUW7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:59:20 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:23859 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYJUW7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:59:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eN+sogMElhVyxb23jRbCeyx8HbHorvhzq3tErYV8ScZyEPHWcVxOc8aS2sFNBL1899
         Nxi/KvtRPj4e17LI3u8P60Rp/oyROliQzMyPZZ2jiezN8kZOonLDrSNr4MOZMwWfxAKh
         kIo9+ZtChY3pCl59WLhXQGVKwbVpsAAv45XfA=
Message-ID: <eada2a070810211559u6a040d29y11d1235557ac44f3@mail.gmail.com>
Date: Tue, 21 Oct 2008 15:59:16 -0700
From: "Tim Pepper" <tpepper@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] lockstat: contend with points
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       "=?ISO-8859-1?Q?T=F6r=F6k_Edwin?=" <edwintorok@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Bill Huey" <billh@gnuppy.monkey.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
In-Reply-To: <1224231505.28131.71.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224231505.28131.71.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 1:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> +06                          &mm->mmap_sem-W:           233            538 18446744073708       22924.27      607243.51           1342          45806           1.71        8595.89     1180582.34
> +07                          &mm->mmap_sem-R:           205            587 18446744073708       28403.36      731975.00           1940         412426           0.58      187825.45     6307502.88
> +08                          ---------------
> +09                            &mm->mmap_sem            487          [<ffffffff8053491f>] do_page_fault+0x466/0x928
> +10                            &mm->mmap_sem            179          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
> +11                            &mm->mmap_sem            279          [<ffffffff80210a57>] sys_mmap+0x75/0xce
> +12                            &mm->mmap_sem             76          [<ffffffff802a490b>] sys_munmap+0x32/0x59
> +13                          ---------------
> +14                            &mm->mmap_sem            270          [<ffffffff80210a57>] sys_mmap+0x75/0xce
> +15                            &mm->mmap_sem            431          [<ffffffff8053491f>] do_page_fault+0x466/0x928
> +16                            &mm->mmap_sem            138          [<ffffffff802a490b>] sys_munmap+0x32/0x59
> +17                            &mm->mmap_sem            145          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
> +18
> +19 ...............................................................................................................................................................................................
> +20
> +21                              dcache_lock:           621            623           0.52         118.26        1053.02           6745          91930           0.29         316.29      118423.41
> +22                              -----------
> +23                              dcache_lock            179          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
> +24                              dcache_lock            113          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
> +25                              dcache_lock             99          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
> +26                              dcache_lock            104          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a
> +27                              -----------
> +28                              dcache_lock            192          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
> +29                              dcache_lock             98          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
> +30                              dcache_lock             72          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
> +31                              dcache_lock            112          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a



Just out of curiousity...what was running as you collected these?
