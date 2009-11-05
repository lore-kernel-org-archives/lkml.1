Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbZKEWST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbZKEWST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 17:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758942AbZKEWST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 17:18:19 -0500
Received: from mail-px0-f179.google.com ([209.85.216.179]:37524 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941AbZKEWSS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 17:18:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LTYEwHLW3fZ2NTbFrVHvS2togvYaowTon8P7Nc9Qzkd3jC4nPAxPD/L5SuGoDL746w
         DyAosPJHYIR0p3Wo5jhwQci6PitVwtOkV0uioPvayjHAsN5Z8/S4FEq8znDdBFHttjNu
         JSisOSmDfYdCJaGB9gwCl3WobFhA2yEmj684E=
MIME-Version: 1.0
In-Reply-To: <loom.20091105T213323-393@post.gmane.org>
References: <20091030063216.GA30712@gamma.logic.tuwien.ac.at>
	 <20091102005218.8352.A69D9226@jp.fujitsu.com>
	 <20091102135640.93de7c2a.minchan.kim@barrios-desktop>
	 <28c262360911012300h4535118ewd65238c746b91a52@mail.gmail.com>
	 <20091102155543.E60E.A69D9226@jp.fujitsu.com>
	 <20091102140216.02567ff8.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091102141917.GJ2116@gamma.logic.tuwien.ac.at>
	 <28c262360911020640k3f9dfcdct2cac6cc1d193144d@mail.gmail.com>
	 <20091105132109.GA12676@gamma.logic.tuwien.ac.at>
	 <loom.20091105T213323-393@post.gmane.org>
Date: Fri, 6 Nov 2009 07:18:23 +0900
Message-ID: <28c262360911051418r1aefbff6oa54a63d887c0ea48@mail.gmail.com>
Subject: Re: OOM killer, page fault
From: Minchan Kim <minchan.kim@gmail.com>
To: Norbert Preining <preining@logic.at>, Jody Belka <jody+lkml@jj79.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 6, 2009 at 5:37 AM, Jody Belka <jody+lkml@jj79.org> wrote:
> Norbert Preining <preining <at> logic.at> writes:
>> Don't ask me why, please, and I don't have a serial/net console so that
>> I can tell you more, but the booting hangs badly at:
>
> <snip>
>
>>
>> > diff --git a/mm/memory.c b/mm/memory.c
>> > index 7e91b5f..47e4b15 100644
>> > --- a/mm/memory.c
>> > +++ b/mm/memory.c
>> > @@ -2713,7 +2713,11 @@ static int __do_fault(struct mm_struct *mm,
>> > struct vm_area_struct *vma,
>> >        vmf.page = NULL;
>> >
>> >        ret = vma->vm_ops->fault(vma, &vmf);
>> > -       if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
>> > +       if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE))) {
>> > +               printk(KERN_DEBUG "vma->vm_ops->fault : 0x%lx\n",
>> > vma->vm_ops->fault);
>> > +               WARN_ON(1);
>> > +
>> > +       }
>> >                return ret;
>> >
>> >        if (unlikely(PageHWPoison(vmf.page))) {
>>
>
> Erm, could it not be due to the "return ret;" line being moved outside of the
> if(), so that it always executes?

Right. Sorry it's my fault.
I become  blind.
'return ret' should be inclueded in debug code.

>
>
> J
>
> ps, sending this through gmane, don't know if it'll keep cc's or not, so
> apologies if not. please cc me on any replies
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
