Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYFPMQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYFPMQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbYFPMQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:16:04 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:39096 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbYFPMQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=XnPH2Jd3Ztkp1CDzwmXJB12H0zZi8Mrysy2imODHL9XHjqxDL5UIWs5ajDBzNATxN4
         +eaodoQwZ3Hv3S+g0380ZKpOCSfeuDMZrAMFeH7L3UBzM/kHqrV8grQgqPJhVztjf/yX
         WyhDI9mPe74XTfLPjOEijCtOH+pGQEYz/BZ1k=
Message-ID: <48565951.40603@gmail.com>
Date: Mon, 16 Jun 2008 14:15:13 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: andrea@cpushare.com
CC: Ivana Varekova <varekova@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
Subject: PR_SET_SECCOMP and PR_GET_SECCOMP doc (and bug?)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea,

Below is my attempt to document the SECCOMP prctl() operations that you added
in 2.6.23.  Could you please read, and let me know if I have the details
correct.  Especially take a look at the description of PR_GET_SECCOMP, whose
operation tends to suggest a thinko:

    PR_SET_SECCOMP (since Linux 2.6.23)
        Set the secure computing mode for the calling  thread.   In
        the  current  implementation,  arg2  must  be 1.  After the
        secure computing mode has been set to 1,  the  only  system
        calls  that  the  thread  is permitted to make are read(2),
        write(2), _exit(2), and sigreturn(2).  Other  system  calls
        result in the delivery of a SIGKILL signal.  Secure comput-
        ing mode is useful for number-crunching  applications  that
        may  need  to execute untrusted byte code, perhaps obtained
        by reading from a pipe or socket.  This operation  is  only
        available  if  the kernel is configured with CONFIG_SECCOMP
        enabled.

    PR_GET_SECCOMP (since Linux 2.6.23)
        Return the secure computing mode  of  the  calling  thread.
        Not  very  useful: if the caller is not in secure computing
        mode, this operation returns 0; if the caller is in  secure
        computing  mode, then the prctl() call will cause a SIGKILL
        signal to be sent to the process.  This operation  is  only
        available  if  the kernel is configured with CONFIG_SECCOMP
        enabled.

Have I misunderstood something?  Surely it is not really intended that
PR_GET_SECCOMP be this useless?  The alternatives that I can think of would be
that

a) at least the call prctl(PR_GET_SECCOMP) would be among the set of permitted
syscalls in secure computing mode, or

b) there shouldn't be a prctl(PR_GET_SECCOMP) at all.

Cheers,

Michael

