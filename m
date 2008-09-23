Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbYIWEZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbYIWEZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 00:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYIWEZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 00:25:29 -0400
Received: from main.gmane.org ([80.91.229.2]:35678 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYIWEZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 00:25:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh S <halesh.sadashiv@ap.sony.com>
Subject: Re: Regarding select() on PPC
Date: Tue, 23 Sep 2008 04:25:08 +0000 (UTC)
Message-ID: <loom.20080923T042402-626@post.gmane.org>
References: <loom.20080919T140301-79@post.gmane.org> <loom.20080922T143915-56@post.gmane.org> <jeskrs42gg.fsf@sykes.suse.de> <loom.20080922T154432-962@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 59.96.48.15 (Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Halesh S <halesh.sadashiv <at> ap.sony.com> writes:

> 
> Andreas Schwab <schwab <at> suse.de> writes:
> 
> > 
> > Halesh S <halesh.sadashiv <at> ap.sony.com> writes:
> > 
> > > What is the purpose of Argument check only for PPC32, is ther any 
specific 
> > > reason?
> > 
> > Probably long obsolete, it predates linux 2.2.0.
> 
>   Than do you mean by this is not required in later versions.
> 
> > 
> > Andreas.
> > 
> 
> Thanks,
> Halesh
> 
> 


Halesh S <halesh.sadashiv <at> ap.sony.com> writes:

> 
> Andreas Schwab <schwab <at> suse.de> writes:
> 
> > 
> > Halesh S <halesh.sadashiv <at> ap.sony.com> writes:
> > 
> > > What is the purpose of Argument check only for PPC32, is ther any 
specific 
> > > reason?
> > 
> > Probably long obsolete, it predates linux 2.2.0.
> 
>   Than do you mean by this is not required in later versions.
> 
> > 
> > Andreas.
> > 
> 
> Thanks,
> Halesh
> 
> 

Please check this patch be applied for latest linux kernel??

--- arch/powerpc/kernel.old/syscalls.c  2008-09-22 20:47:06.000000000 +0530
+++ arch/powerpc/kernel/syscalls.c      2008-09-23 09:38:31.841327576 +0530
@@ -203,25 +203,13 @@

 #ifdef CONFIG_PPC32
 /*
- * Due to some executables calling the wrong select we sometimes
- * get wrong args.  This determines how the args are being passed
- * (a single ptr to them all args passed) then calls
- * sys_select() with the appropriate args. -- Cort
+ * The argument checking is long obselete, the code was carried from
+ * kernel version 2.2.0, so removing obselete code and directly call
+ * to sys_select()
  */
 int
 ppc_select(int n, fd_set __user *inp, fd_set __user *outp, fd_set __user 
*exp, struct timeval __user *tvp)
 {
-   if ( (unsigned long)n >= 4096 )
-   {
-       unsigned long __user *buffer = (unsigned long __user *)n;
-       if (!access_ok(VERIFY_READ, buffer, 5*sizeof(unsigned long))
-           || __get_user(n, buffer)
-           || __get_user(inp, ((fd_set __user * __user *)(buffer+1)))
-           || __get_user(outp, ((fd_set  __user * __user *)(buffer+2)))
-           || __get_user(exp, ((fd_set  __user * __user *)(buffer+3)))
-           || __get_user(tvp, ((struct timeval  __user * __user *)
(buffer+4))))
-               return -EFAULT;
-   }
    return sys_select(n, inp, outp, exp, tvp);
 }
 #endif

Tested on PPC32. Works fine with provided testcase.

Thanks,
Halesh

