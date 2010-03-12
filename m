Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab0CLXiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:38:10 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54436 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0CLXiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:38:07 -0500
Subject: gcc and kernel build trouble report
From: Keith Mannthey <kmannth@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: James Smart <james.smart@Emulex.Com>, Richard Lary <rlary@us.ibm.com>
Content-Type: text/plain
Date: Fri, 12 Mar 2010 15:38:05 -0800
Message-Id: <1268437085.7745.62.camel@keith-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

  At the start of the week I moved kernels forwarded.  I tried
2.6.34-rc1 and 2.6.33-git15.  The lpfc fiber channel driver was failing
to load and generating a hardware level pci bus fault that was resetting
the server.  There is a small thread on linux-scsi from when I started. 

  Tried forward porting know working versions of the driver to the new
kernels but it did not fix the problem. I have to reason to suspect the
actual code in the driver is not really involved with the issue. 

  I booted whole older kernels until I sorted out that somewhere post
2.6.33 stock that issue started. I am not 100% sure where in the kernel
commits the problem starts I just know if is after 2.6.33. 

  It was identified that an alternate .config file worked and I decided
to dig on the config options. 

  I narrowed the config change down to:

CONFIG_CC_OPTIMIZE_FOR_SIZE

  I have to set CONFIG_CC_OPTIMIZE_FOR_SIZE=y else I get a pci fault
while failing to load the lpfc driver. As I understand this passes a
different -O flag to the build. 


Relevant details:

Hardware:  IBM x3550m2 server. Current Intel based 2 socket system,
nothing fancy. 

GCC:  gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) 

Kernels: For sure, 2.6.34-rc1, 2.6.33-git15 have the problem.  If the 10
or so 2.6.33 and before kernels trees I have booted I did not encounter
the issue. 

Config: CONFIG_CC_OPTIMIZE_FOR_SIZE=y or bad things happen. I booted a
ton of .config changes, 100% sure this is it, it has been triple
checked. 

  All in all not a fun experience and I don't really have the skills to
fix this issue.  I am going to try a different gcc version when I get a
few cycles. 

 Any suggestions on what to do with this gcc / kernel build issue? I
found it a little unsettling. 

Thanks,
 Keith Mannthey
 LTC FS-Dev 





