Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbXA1QeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbXA1QeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 11:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXA1QeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 11:34:20 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:39685 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbXA1QeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 11:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jeKozqqCA0JOW4vithoq1hlePz0XVS8vUfE3aqVZFNL89XVx4GV2Lnnxf0BJR5UbBNkE1nXkQPEeXzlynMidZkco8Ru52I6dd1gx5Qm2h0Y9Ujm/etEr8SM4Ieo9ZClrieU+10QnUFDJEKTSbGSMKIfZr+EkYQWVKCD0D2zHsOA=
Message-ID: <82e4877d0701280834n75d3d0d3ja7a35d5ea0e7fa4f@mail.gmail.com>
Date: Sun, 28 Jan 2007 11:34:19 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: thunder7@xs4all.nl
Subject: RE: 2.6.20-rc6-mm1: linker error with arch_setup_additional_pages
Cc: "akpm@osdl.org" <akpm@osdl.org>, ak@suse.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>CONFIG_BINFMT_ELF=y
># CONFIG_BINFMT_MISC is not set
># CONFIG_IA32_EMULATION is not set

Hm Ok. That's explainable. You don't have CONFIG_IA32_EMULATION set
and arch_setup_additional pages is only defined/exported in
syscall32.c which won't be built in your case. (It should go away if
you set CONFIG_IA32_EMULATION).

Andi - Is arch_setup_additional_pages required for x86_64 without
IA32? If so what should it call (like it calls syscall32_setup_pages
in IA32 case)? If it is not needed I guess we can make it a no-op in
case IA32_EMULATION=n?

linux/interp.h -
#ifdef CONFIG_X86_64 && !defined CONFIG_IA32_EMULATION
static inline int arch_setup_additional_pages(struct linux_binprm *bprm,
                                int executable_stack)
{
        return 0;
}


Perhaps we  need an arch-specific override for interp.h?

Parag
