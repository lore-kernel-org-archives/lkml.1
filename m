Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXBSCCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXBSCCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 21:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXBSCCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 21:02:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:37251 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXBSCCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 21:02:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=H9RlQgORinB6BjiQiYkChrhWGCXkFXTVLMDSc2M907I8DOwszn4MeX0BBEl+fqY/DmUFn85pNddJPRHl1wRdpPohmfN+7x5VNu9x8rUgLe42h6D8UfEDik4irO1gWxd1RA7VP85vaTGDZSGZB34/Tx/WvoMkbxMebfOlZnxGeKk=
Message-ID: <2fe399760702181802q39e75b42iea7f80124506f169@mail.gmail.com>
Date: Sun, 18 Feb 2007 18:02:17 -0800
From: "Phy Prabab" <phyprabab@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about setting affinity in 2.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I am trying to set affinity on a program to make sure I can get the
best use of the cache as possible and to eliminate as much noise as
possible with running my program.  I have tried unsuccessfully to set
affinity using sched_set/getaffinity and the CPU_SET macros.  In
particular, I can not seem to get the process to use affinity I
specify as in:

int main () {
  cpu_set_t mask;
  cpu_set_t setmask;
  long long x;
  double foo;
  printf("Mask set to %08lx\n", sched_getaffinity(0, &mask));
  CPU_SET(1, &mask);
  if (sched_setaffinity(0, &mask) == -1) {
     printf("error setting affinity.");
  }

  printf("Mask is reset to %08lx\n", sched_getaffinity(0, &mask));
  // do some long lasting calculations ....

  return;
}

No mater what I do, the process is never bond to the processor in
question as exposed by this little appy and by cat /proc/<pid>/cpu.
Is this just impossible to do?

Ah, the kernel I am using is RH 2.4.21-37.ELsmp.

TIA!
Phy
