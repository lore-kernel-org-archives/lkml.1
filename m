Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbXHQNcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbXHQNcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 09:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXHQNci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 09:32:38 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:43564 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXHQNch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 09:32:37 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [kvm-devel] [PATCH/RFC 3/4]Introduce "account modifiers"=?iso-8859-15?q?=09mechanism?=
Date: Fri, 17 Aug 2007 15:32:32 +0200
User-Agent: KMail/1.9.7
Cc: Avi Kivity <avi@qumranet.com>, Rusty Russell <rusty@rustcorp.com.au>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
References: <46C4719A.2060308@bull.net> <46C59AB1.6070505@qumranet.com> <46C59DC6.4020308@bull.net>
In-Reply-To: <46C59DC6.4020308@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171532.32850.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 17. August 2007 schrieb Laurent Vivier:
> > The normal user/system accounting has the same issue, no?  Whereever we
> > happen to land (kernel or user) gets the whole tick.
> 
> Yes... but perhaps I should rewrite this too ;-)

If you look further, you will see, that this was actually rewritten in 2.6.12 
and thats why we have cputime_t. The infrastructure is currently only used by 
s390 and ppc64. On s390 we use our cpu timer to get the current time on each 
syscall/irq/context switch etc to get precise accounting data for 
system/user/irq/softirq/nice. We also get steal time (this is interesting for 
the guest: how much of my cpu was actually not available because the 
hypervisor scheduled me away). I dont know enough about other architectures  
to say which one could exploit this infrastructure as well.

The current git tree is somewhat broken for CONFIG_VIRT_CPU_ACCOUTING due to 
the accouting changes introduced by CFS - we work on this.

If you are interested in the cputime stuff, you can have a look at 
arch/s390/kernel/vtime.c (account_system_vtime, account_vtime) as well as:

http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commit;h=6be7071fdd321c206b1ee7a3e534782f25572830
for the first introduction and
http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commit;h=db59f519d37f80683f3611927f6b5c3bdfc0f9e6
for the s390 exploitation.

Christian
