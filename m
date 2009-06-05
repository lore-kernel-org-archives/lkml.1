Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZFEAzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZFEAzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZFEAzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:55:39 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:63882 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZFEAzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KqFJy8BN9dD61Qd9tEEIjh/5vcrHUmQQFl7mFsR+UQ3CeSAS4C9K6s5mIyDntapkna
         npOctoDzHsARAFaF2LjyhAOMSVj+023HdkqBRI5Hj3zK0QIK21CQOtZOCOeBY8VJUuAP
         KQUBrsfLnmOlYzpNi5gafxvcZ61bA/SUhozOI=
MIME-Version: 1.0
In-Reply-To: <20090604175030.55cc4a68.akpm@linux-foundation.org>
References: <1243927050-30685-1-git-send-email-vapier@gentoo.org>
	 <20090604175030.55cc4a68.akpm@linux-foundation.org>
Date: Thu, 4 Jun 2009 20:55:40 -0400
Message-ID: <8bd0f97a0906041755q7588ba76l1e4e1eb8bdbe336@mail.gmail.com>
Subject: Re: [PATCH] kgdbts: unify/generalize gdb breakpoint adjustment
From: Mike Frysinger <vapier.adi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: jason.wessel@windriver.com, kgdb-bugreport@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 20:50, Andrew Morton wrote:
> On Tue,  2 Jun 2009 03:17:30 -0400
> Mike Frysinger <vapier@gentoo.org> wrote:
>
>> +     instruction_pointer(&kgdbts_regs) += offset;
>
> instruction_pointer() cannot be used as an lvalue, thankfully.
>
> x86_64:
>
> drivers/misc/kgdbts.c: In function 'check_and_rewind_pc':
> drivers/misc/kgdbts.c:306: error: invalid lvalue in assignment

should be easy to fix:
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -236,10 +236,7 @@
 #endif
 }

-static inline unsigned long instruction_pointer(struct pt_regs *regs)
-{
-   return regs->ip;
-}
+#define instruction_pointer(regs) ((regs)->ip)

 static inline unsigned long frame_pointer(struct pt_regs *regs)
 {
-mike
