Return-Path: <linux-kernel-owner+w=401wt.eu-S932443AbZGABVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbZGABVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764118AbZGAAwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:52:33 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:41884 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764111AbZGAAwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GyGFpRgqAFi5K5k3hwDEsR+bp6sdSlHCgpYUSWdpBadKkVoUVrJszu38M6AdgQryJy
         StVZxlbm4kTfeOC7IhCdqK4EeFZq7BpWjuJ4L2TAgp9pGY7yX/V1dM68jNv51BY9AL7W
         qHA1TT+PYdavxKAKwujJhMHsNQypF+wuDDFNc=
Date: Wed, 1 Jul 2009 08:54:37 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the multithread program core thread message error
Message-ID: <20090701005437.GA5856@cr0.nay.redhat.com>
References: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Hui.

On Tue, Jun 30, 2009 at 05:12:31PM +0800, Hui Zhu wrote:
>Fix the multithread program core thread message error.
>The thread message of core file is generated in
>elf_dump_thread_status.  The register values is set by
>elf_core_copy_task_regs in this function.
>static inline int elf_core_copy_task_regs(struct task_struct *t,
>					   elf_gregset_t* elfregs)
>{
>
>	return ELF_CORE_COPY_TASK_REGS(t, elfregs);
>	return 0;
>}
>If a arch doesn't define ELF_CORE_COPY_TASK_REGS, This function will do
>nothing.  Then the core file will not have the register message of
>thread.
>So add elf_core_copy_regs to set regiser values if
>ELF_CORE_COPY_TASK_REGS doesn't define.


You forgot your Signed-off-by line. :)

Hmmm, this patch looks sane for me. But could you please
send us your test program? i.e. how did you test this?

Thank you!


>---
> elfcore.h |    2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
>index 7605c5e..03ec167 100644
>--- a/include/linux/elfcore.h
>+++ b/include/linux/elfcore.h
>@@ -125,6 +125,8 @@ static inline int elf_core_copy_task_regs(struct
>task_struct *t, elf_gregset_t*
> #ifdef ELF_CORE_COPY_TASK_REGS
>
>        return ELF_CORE_COPY_TASK_REGS(t, elfregs);
>+#else
>+       elf_core_copy_regs(elfregs, task_pt_regs(t));
> #endif
>        return 0;
> }
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
