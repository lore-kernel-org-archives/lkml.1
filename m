Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZKBOkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZKBOkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbZKBOkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:40:39 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59830 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbZKBOkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rqrXUu3jGgmi0SsY+Xbv6+a6fo27M6qgAR93SocUXx53kRNTyP2MtK6wYVaYof6Xvq
         XObx/2Dd67F5A2NU7z7H7Ncd7OlS5xmpYLFypDmt2rOY6xG7sIGoEenC4kCKMW3RDlYW
         Bmv+kusLLDHW0C4DhZVjbd9PZ6Fqa1kIi8rwo=
MIME-Version: 1.0
In-Reply-To: <20091102141917.GJ2116@gamma.logic.tuwien.ac.at>
References: <20091030063216.GA30712@gamma.logic.tuwien.ac.at>
	 <20091102005218.8352.A69D9226@jp.fujitsu.com>
	 <20091102135640.93de7c2a.minchan.kim@barrios-desktop>
	 <28c262360911012300h4535118ewd65238c746b91a52@mail.gmail.com>
	 <20091102155543.E60E.A69D9226@jp.fujitsu.com>
	 <20091102140216.02567ff8.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091102141917.GJ2116@gamma.logic.tuwien.ac.at>
Date: Mon, 2 Nov 2009 23:40:43 +0900
Message-ID: <28c262360911020640k3f9dfcdct2cac6cc1d193144d@mail.gmail.com>
Subject: Re: OOM killer, page fault
From: Minchan Kim <minchan.kim@gmail.com>
To: Norbert Preining <preining@logic.at>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Nov 2, 2009 at 11:19 PM, Norbert Preining <preining@logic.at> wrote:
> Hi all,
>
> wow, many messages ... At the end I lost track of which patch I should try?
>
> BTW, that happened only once, and whatever I do I cannot reproduce that.
>
> I will anyway include any patch you send me and hope that it happens again.

Pz forget my previous patch.
Could you test following patch?

diff --git a/mm/memory.c b/mm/memory.c
index 7e91b5f..47e4b15 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2713,7 +2713,11 @@ static int __do_fault(struct mm_struct *mm,
struct vm_area_struct *vma,
       vmf.page = NULL;

       ret = vma->vm_ops->fault(vma, &vmf);
-       if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
+       if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
+               printk(KERN_DEBUG "vma->vm_ops->fault : 0x%lx\n",
vma->vm_ops->fault);
+               WARN_ON(1);
+
+       }
               return ret;

       if (unlikely(PageHWPoison(vmf.page))) {


> Thanks
>
> Norbert
>
> -------------------------------------------------------------------------------
> Dr. Norbert Preining                                        Associate Professor
> JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
> Vienna University of Technology                               preining@logic.at
> Debian Developer (Debian TeX Task Force)                    preining@debian.org
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> BAUMBER
> A fitted elasticated bottom sheet which turns your mattress
> bananashaped.
>                        --- Douglas Adams, The Meaning of Liff
>



-- 
Kind regards,
Minchan Kim
