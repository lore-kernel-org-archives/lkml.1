Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbXHTUSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbXHTUSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbXHTUSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:18:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbXHTUSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:18:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Dave Jones <davej@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [POWERPC] Fix for assembler -g
In-Reply-To: Dave Jones's message of  Monday, 20 August 2007 16:08:56 -0400 <20070820200856.GA4194@redhat.com>
Emacs: because one operating system isn't enough.
Message-Id: <20070820201818.A68C54D05F2@magilla.localdomain>
Date: Mon, 20 Aug 2007 13:18:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm still seeing failures with this.
> http://koji.fedoraproject.org/koji/getfile?taskID=110854&name=build.log
> shows..
> 
> lparmap.c: Assembler messages:
> lparmap.c:84: Error: file number 1 already allocated
> make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
> 
> Anything I can provide to help diagnose this?

Hmm.  Check the V=1 make output to see that the lparmap.c really got the -g0.
The log says it didn't.  Oops!  It looks like the patch that got committed is
the one that sets CFLAGS_lparmap.s, but really it needs to set
CFLAGS_lparmap.o instead (go kbuild).  Did I post the wrong one?  (It's only
one letter different.)  Sorry about that!  (I committed the right one to
Fedora, which you'd think would help Dave, but no.)


Thanks,
Roland


--- linux-2.6/arch/powerpc/kernel/Makefile
+++ linux-2.6/arch/powerpc/kernel/Makefile
@@ -81,6 +81,7 @@ obj-y				+= iomap.o
 endif
 
 ifeq ($(CONFIG_PPC_ISERIES),y)
+CFLAGS_lparmap.o		+= -g0
 extra-y += lparmap.s
 $(obj)/head_64.o:	$(obj)/lparmap.s
 AFLAGS_head_64.o += -I$(obj)


