Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbYHZILk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbYHZILk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYHZIL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:11:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:23323 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbYHZILZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sohD4EzP2xqC3nD0zumUNoa/YSWEAgKaJ+xsfiCe35IFAKPHzdaPdFfAG9htOs+lyJ
         MRqQKo5qAeFBIbXw86dNEAx2Eb4td/eTDDja+I/bbC9B5PDC56xF44KPJCxjbiyKNZSC
         nuXuGeS52qZG1NP+lnOvemC+f4+2kier0qlac=
Message-ID: <b647ffbd0808260111r2aed706cvc4c5d483912ec8c2@mail.gmail.com>
Date: Tue, 26 Aug 2008 10:11:24 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ryan Hope" <rmh3093@gmail.com>
Subject: Re: [-mmotm] BUG: scheduling while atomic: swapper
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/26 Ryan Hope <rmh3093@gmail.com>:
> BUG: scheduling while atomic: swapper/1/0x00000002
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc4-zenmmotm1 #4
>  [<c057a0c7>] schedule+0x287/0x6d0
>  [<c03672e6>] vsnprintf+0x3a6/0x6c0
>  [<c057a92d>] schedule_timeout+0x7d/0xb0
>  [<c021e0c8>] __wake_up+0x38/0x50
>  [<c057a74a>] wait_for_common+0x8a/0x130
>  [<c0220ab0>] default_wake_function+0x0/0x10
>  [<c0237743>] call_usermodehelper_exec+0xc3/0xf0
>  [<c0362ede>] kobject_uevent_env+0x37e/0x3a0
>  [<c03d5921>] device_add+0x551/0x630
>  [<c03d5ac3>] device_create_vargs+0xb3/0xd0
>  [<c06ccc47>] microcode_intel_module_init+0x0/0x39

It doesn't look like Linus's tree... there is no
microcode_intel_module_init() in .27+. So what is it?

Anyway, your trace might be explained by a bug that has been already
fixed in Ingo's -tip.

Here is the commit:
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=8343ef2437c599d30568e6b5a257a40bf2f4902b


-- 
Best regards,
Dmitry Adamushko
