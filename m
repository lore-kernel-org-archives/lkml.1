Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbXLMNY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbXLMNY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXLMNYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:24:51 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:44005 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752333AbXLMNYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:24:50 -0500
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
From: Vincent Fortier <vincent.fortier1@ec.gc.ca>
Reply-To: vincent.fortier1@ec.gc.ca
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kay.sievers@vrfy.org,
       Balbir Singh <balbir@in.ibm.com>, maneesh@in.ibm.com
In-Reply-To: <20071213130231.GB16905@linux.vnet.ibm.com>
References: <20071211182015.GA22339@linux.vnet.ibm.com>
	 <20071211182528.GA5597@linux.vnet.ibm.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B0015201F1@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071211210653.GA6902@elte.hu> <20071212070816.GA31455@linux.vnet.ibm.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B0015201F6@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071212134158.GA5547@linux.vnet.ibm.com>
	 <F1D642E5A91BC94D9504EC83AE19E6B00152021F@ecqcmtlmail3.quebec.int.ec.gc.ca>
	 <20071213114336.GA5400@linux.vnet.ibm.com> <20071213125509.GA28340@elte.hu>
	 <20071213130231.GB16905@linux.vnet.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Environnement Canada
Date: Thu, 13 Dec 2007 13:24:26 +0000
Message-Id: <1197552266.4936.2.camel@kayak.wul.qc.ec.gc.ca>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
X-OriginalArrivalTime: 13 Dec 2007 13:24:27.0113 (UTC) FILETIME=[7C0E7590:01C83D8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-13 at 18:32 +0530, Dhaval Giani wrote:
> On Thu, Dec 13, 2007 at 01:55:09PM +0100, Ingo Molnar wrote:
> > 
> > * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > 
> > > Could you please see if the following patch removes the oops due to 
> > > CFS sysfs files? (There might still be the other oops due to the 
> > > floppy sysfs files)
> > > 
> > > Ingo, could you please add this patch in your CFS backport to 2.6.22 
> > > and older kernels?
> > 
> > sure - i've updated the backport patches with this fix.
> > 
> 
> Thanks!

CFS v24 now does not apply correctly on a 2.6.22.15-rc1 here:
--- 31,43 ----
  #include <linux/cn_proc.h>
  #include <linux/getcpu.h>
  #include <linux/task_io_accounting_ops.h>
+ #include <linux/seccomp.h>
  #include <linux/cpu.h>

  #include <linux/compat.h>
  #include <linux/syscalls.h>
  #include <linux/kprobes.h>
+ #include <linux/user_namespace.h>

  #include <asm/uaccess.h>
  #include <asm/io.h>


due to [patch 31/36] Revert "Fix SMP poweroff hangs
which removes:
-#include <linux/cpu.h>


About to build/test this morning.

thnx.

- vin


> 
> > >  static void user_attr_init(struct subsys_attribute *sa, char *name, int mode)
> > >  {
> > > +	sa->attr.owner = NULL;
> > >  	sa->attr.name = name;
> > 
> > i'm wondering why doesnt this affect 2.6.23 and later? Does sysfs 
> > initialize the owner field to NULL automatically?
> > 
> 
> Going through git log, it seems that commit
> 7b595756ec1f49e0049a9e01a1298d53a7faaa15 deemed attribute->owner as
> unnecessary. I guess that answers the question.
> 
