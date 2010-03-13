Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab0CMK6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 05:58:12 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:35228 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758965Ab0CMK6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 05:58:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19355.28592.418635.593520@pilspetsen.it.uu.se>
Date: Sat, 13 Mar 2010 11:57:52 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, James Smart <james.smart@Emulex.Com>,
       Richard Lary <rlary@us.ibm.com>
Subject: Re: gcc and kernel build trouble report
In-Reply-To: <1268437085.7745.62.camel@keith-laptop>
References: <1268437085.7745.62.camel@keith-laptop>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Mannthey writes:
 > Hello, 
 > 
 >   At the start of the week I moved kernels forwarded.  I tried
 > 2.6.34-rc1 and 2.6.33-git15.  The lpfc fiber channel driver was failing
 > to load and generating a hardware level pci bus fault that was resetting
 > the server.  There is a small thread on linux-scsi from when I started. 
 > 
 >   Tried forward porting know working versions of the driver to the new
 > kernels but it did not fix the problem. I have to reason to suspect the
 > actual code in the driver is not really involved with the issue. 
 > 
 >   I booted whole older kernels until I sorted out that somewhere post
 > 2.6.33 stock that issue started. I am not 100% sure where in the kernel
 > commits the problem starts I just know if is after 2.6.33. 
 > 
 >   It was identified that an alternate .config file worked and I decided
 > to dig on the config options. 
 > 
 >   I narrowed the config change down to:
 > 
 > CONFIG_CC_OPTIMIZE_FOR_SIZE
 > 
 >   I have to set CONFIG_CC_OPTIMIZE_FOR_SIZE=y else I get a pci fault
 > while failing to load the lpfc driver. As I understand this passes a
 > different -O flag to the build. 
 > 
 > 
 > Relevant details:
 > 
 > Hardware:  IBM x3550m2 server. Current Intel based 2 socket system,
 > nothing fancy. 
 > 
 > GCC:  gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) 
 > 
 > Kernels: For sure, 2.6.34-rc1, 2.6.33-git15 have the problem.  If the 10
 > or so 2.6.33 and before kernels trees I have booted I did not encounter
 > the issue. 
 > 
 > Config: CONFIG_CC_OPTIMIZE_FOR_SIZE=y or bad things happen. I booted a
 > ton of .config changes, 100% sure this is it, it has been triple
 > checked. 
 > 
 >   All in all not a fun experience and I don't really have the skills to
 > fix this issue.  I am going to try a different gcc version when I get a
 > few cycles. 
 > 
 >  Any suggestions on what to do with this gcc / kernel build issue? I
 > found it a little unsettling. 

Report it to SuSE, who apparently supplied the gcc-4.3.4 you're having
issues with.

You can also try using self-compiled vanilla gcc-4.3.4 or better 4.4.3.

And you can analyze the miscompilation and construct a user-mode test
case, although doing that can be difficult and time-consuming.
