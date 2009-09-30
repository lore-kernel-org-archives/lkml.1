Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZI3SCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZI3SCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 14:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZI3SCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 14:02:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbZI3SCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 14:02:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Date: Wed, 30 Sep 2009 19:59:40 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.27-8-eeepc; KDE/4.2.2; i686; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
References: <20090924165548.GA16586@us.ibm.com> <200909301815.45211.arnd@arndb.de> <alpine.LFD.2.01.0909300925170.6996@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0909300925170.6996@localhost.localdomain>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909301959.41706.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+jqhxLrErmtvpnHNW+ekdPEx59k3nF47LeT4w
 lKkLWwAd8vjRcwAQuUVaAGOn8v1TOYw1U6xyQQhdriDhcaI766
 lBNA41Q9Zw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 September 2009, Linus Torvalds wrote:
> Umm. I don't think that is possible.
> 
> You need architecture-specific code to even get access to all registers to 
> copy and get a signal-handler-compatible stack frame. See for example 
> arch/alpha/kernel/entry.S with the switch-stack thing etc.  I don't think 
> there is any way to make that even remotely architecture-neutral.

Right, you still need to save all the registers from the entry code.
I was under the wrong assumption that task_pt_regs(current)
would give the full register set on all architectures.

However, I'd still hope that a new system call can be defined in
a way that you only need to have an assembly wrapper to save
the full pt_regs, but no arch specific code to get the syscall arguments
out of that again. In do_clone(), you need a pointer to pt_regs and
the user stack pointer, but that can be generated from
user_stack_pointer(regs).

Does task_pt_regs(current) give the right pointer on all architectures
or do we also need to pass the regs into the syscall?

	Arnd <><
