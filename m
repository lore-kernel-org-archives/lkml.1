Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXH0OIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXH0OIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 10:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbXH0OIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 10:08:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:40554 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbXH0OIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 10:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=bQMC55s+L9a1u2N2uYimqXTbDC8P1qn19Sz2yCGVW87UEsBdOpCvxUY8J2ETQqzUC+K++zc0Ifi4IqVIMFn6e5BvFDaKfAt9G3Mbj0hqgqMnleSAScCxMkRuD+NsCo3yIw44hOf4guC5UKM+cwnIvuiGZ8pOCV7VVwyqR+BD8l8=
Message-ID: <46D2DADF.8060505@gmail.com>
Date: Mon, 27 Aug 2007 16:08:31 +0200
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: arch_align_stack() seems useless
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

I recently pick up the implementation of arch_align_stack() from x86
architectures to make it available for mips.

But now I just realised that this function seems useless because of
the way it's used.

Currently, this function seems to be only used to randomize the stack
pointer inside a page during an execve() syscall. Only i386, x86_64
and recently mips do that. Here is the code taken from exec.c which
calls it:

	int setup_arg_pages(struct linux_binprm *bprm,
			    unsigned long stack_top,
			    int executable_stack)
	{
		[...]
	
		stack_top = arch_align_stack(stack_top);
		stack_top = PAGE_ALIGN(stack_top);
	
		[...]
	}

Since PAGE_ALIGN() is called right after arch_align_stack(), it seems
to me that the call to the latter function is useless...

Am I missing something ?

thanks

		Franck
