Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbZAHIbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbZAHIbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZAHIb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:31:27 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56904 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZAHIb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:31:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Subject: Re: 2.6.29 -mm merge plans
Cc: kosaki.motohiro@jp.fujitsu.com, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Waychison <mikew@google.com>
In-Reply-To: <604427e00901072357xbe39b1bu3e9f956640ede322@mail.gmail.com>
References: <20090108134014.BFB2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <604427e00901072357xbe39b1bu3e9f956640ede322@mail.gmail.com>
Message-Id: <20090108172548.B932.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  8 Jan 2009 17:31:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> yes. the change is in the last few lines of the patch. I found out
> that the flags was set as FAULT_FLAG_WRITE no matter what(write/read)
> whence FAULT_FLAG_RETRY is set. the new patch changed the logic which
> only set the flag in the "write" case.
> 
> @@ -2713,8 +2720,10 @@ static int do_linear_fault(struct mm_struct *mm, struct
>  {
>        pgoff_t pgoff = (((address & PAGE_MASK)
>                        - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> -       unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
> 
> +       int write = write_access & ~FAULT_FLAG_RETRY;
> +       unsigned int flags = (write ? FAULT_FLAG_WRITE : 0);

ok. it seems makes sense.
thanks.


