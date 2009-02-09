Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZBIX7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZBIX7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbZBIX7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:59:06 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38938 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbZBIX7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:59:05 -0500
Subject: Re: ima changes to shmem breaks !CONFIG_SHMEM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>, James Morris <jmorris@namei.org>,
       LKML <linux-kernel@vger.kernel.org>, Serge Hallyn <serue@us.ibm.com>
In-Reply-To: <4990A6A2.90107@oracle.com>
References: <8bd0f97a0902090830y11965ayc436fc1157510764@mail.gmail.com>
	 <alpine.LRH.1.10.0902100823170.1282@tundra.namei.org>
	 <8bd0f97a0902091327m3a71bf4ex46a391436481032d@mail.gmail.com>
	 <4990A4ED.7020901@oracle.com>
	 <8bd0f97a0902091351p4a719809gf1f2119735f0430f@mail.gmail.com>
	 <4990A6A2.90107@oracle.com>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 18:59:01 -0500
Message-Id: <1234223941.3114.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 13:56 -0800, Randy Dunlap wrote:
> Mike Frysinger wrote:
> > On Mon, Feb 9, 2009 at 16:49, Randy Dunlap wrote:
> >> Mike Frysinger wrote:
> >>> On Mon, Feb 9, 2009 at 16:23, James Morris wrote:
> >>>> On Mon, 9 Feb 2009, Mike Frysinger wrote:
> >>>>> commit 1df9f0a73178718969ae47d813b8e7aab2cf073c broke default building
> >>>>> for Blackfin systems:
> >>>>>   CC      mm/shmem.o
> >>>>> mm/shmem.c: In function 'shmem_zero_setup':
> >>>>> mm/shmem.c:2670: error: implicit declaration of function 'ima_shm_check'
> >>>>> make[1]: *** [mm/shmem.o] Error 1
> >>>>>
> >>>>> that's because the ima.h include was added behind the CONFIG_SHMEM
> >>>>> markings rather than everywhere, just like the function is used.
> >>>> Does this seem like the correct fix?
> >>> it converts the build error to a build warning:
> >>>   CC      mm/shmem.o
> >>> In file included from mm/shmem.c:32:
> >>> include/linux/ima.h:25: warning: 'struct linux_binprm' declared inside
> >>> parameter list
> >>> include/linux/ima.h:25: warning: its scope is only this definition or
> >>> declaration, which is probably not what you want
> >> Add to the other patch:
> >>
> >> --- linux-next-20090209.orig/include/linux/ima.h
> >> +++ linux-next-20090209/include/linux/ima.h
> >> @@ -8,6 +8,7 @@
> >>  */
> >>
> >>  #include <linux/fs.h>
> >> +struct linux_binprm;
> >>
> >>  #ifndef _LINUX_IMA_H
> >>  #define _LINUX_IMA_H
> >>
> >>
> >>
> >> and it builds for me.
> > 
> > yes, it builds w/out warnings now for me too.  any reason those are
> > outside of _LINUX_IMA_H ?  looks like they should both be inside of
> > that.
> 
> Agreed, that change is also good.
> 
> 
> Thanks.

I posted the patch, forgetting to copy both Mike and you.  Could you
please verify the patch resolves the problem.

Thanks!

Mimi

