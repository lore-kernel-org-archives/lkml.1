Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbXIOIr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbXIOIr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbXIOIrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:47:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:43284 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbXIOIrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=HZY06jk4L4Yj9UF3QZBmsClM40uLnrezN7nPiFQjvRmPZ0KtOs4UnfGOwImVJG24rbg1Aih35ojhYHHC//MUy0gbIWyDJY1rm9EYmRlbP3k0E41M0LDD7zP2zZHqrE3/xMEcZaqG/9QbcPX0mQFnV7GC+HcaQY9ALwltYATn8pQ=
Message-ID: <46EB9BD7.9050209@gmail.com>
Date: Sat, 15 Sep 2007 10:46:15 +0200
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: ELF randomization questions 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a couple questions about the process stack randomization but
I'm not sure who should be CCed for such questions.

I submitted a patch to enable 'inside the page' stack randomization on
MIPS few weeks ago and which has been now committed. But I noticed
that this patch is actually useless because this randomization depends
on ELF_PLATFORM symbol to be defined which it isn't on MIPS. All of
this happens in create_elf_tables() function defined in
fs/binfmt_elf.c.

So my first question is now, why is this dependency for ? Can we
remove it and unconditionally do the 'inside the page' randomization
for platforms that implement it ?  I'm not sure how ELF_PLATFORM is
used, I guess it is used later by ld.so on certain architectures but
dunno how.

The second question is that the stack randomization is currently
mainly part of the elf code, but shouldn't it be put in exec.c and
thus be used by all others binary handlers ?

thanks for any hints.

		Franck
