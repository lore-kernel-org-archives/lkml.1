Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbYIIJPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbYIIJPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYIIJPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:15:36 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39929 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbYIIJPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:15:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18630.16047.62853.611215@harpo.it.uu.se>
Date: Tue, 9 Sep 2008 11:15:27 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: roel kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: invalid tests on unsigned
In-Reply-To: <48C685F6.8020108@gmail.com>
References: <48C685F6.8020108@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roel kluin writes:
 > Using spatch I have found the following occurrences where there is
 > an invalid test on an unsigned.
 > 
 > Some may be not seriously, but just redundant, others may indicate
 > an incorrect assumption (that the variable can be negative).
 > I haven't found time to sort out these.
 > 
 > If I have time I will write patches, but feel free to write one
 > yourself if you want.
 > 
 > Roel
 > 
 > What is shown below is not meant as patch, just for reporting.
 > 
 > ----[ arch/arm/mach-davinci/psc.c, unsigned ]----
 > --- arch/arm/mach-davinci/psc.c	2008-07-19 23:16:48.000000000 +0200
 > @@ -70,7 +70,7 @@ void davinci_psc_config(unsigned int dom
 >  {
 >  	u32 epcpr, ptcmd, ptstat, pdstat, pdctl1, mdstat, mdctl, mdstat_mask;
 >  
 > -	if (id < 0)
 >  		return;
 >  
 >  	mdctl = davinci_readl(DAVINCI_PWR_SLEEP_CNTRL_BASE + MDCTL + 4 * id);

This and similar ones may be objectionable.

 > ----[ arch/sparc64/kernel/process.c, unsigned long ]----
 > --- arch/sparc64/kernel/process.c	2008-08-07 17:53:01.000000000 +0200
 > @@ -593,7 +593,7 @@ asmlinkage long sparc_do_fork(unsigned l
 >  	 * the parent's %o1.  So detect that case and restore it
 >  	 * here.
 >  	 */
 > -	if ((unsigned long)ret >= -ERESTART_RESTARTBLOCK)
 >  		regs->u_regs[UREG_I1] = orig_i1;
 >  
 >  	return ret;

This and similar ones are not wrong. The -constant is converted
to unsigned (which is a well-defined operation) after which an >=u
(greater-or-equal unsigned) is performed.

Also, when posting a patch that touches files in several areas
it's useful to prefix it with a 'diffstat', as that allows people
to quickly see if the patch touches something they're interested in.

/Mikael
