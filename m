Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbYCLBxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbYCLBxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYCLBwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:52:51 -0400
Received: from gw.goop.org ([64.81.55.164]:59859 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbYCLBwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:52:51 -0400
Message-ID: <47D7372A.1010003@goop.org>
Date: Tue, 11 Mar 2008 18:51:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <glommer@gmail.com>, shai@scalex86.org
Subject: Re: 2.6.25-rc5-mm1 (paravirt/vsmp/no PCI)
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <20080311100955.ca113f90.randy.dunlap@oracle.com> <47D6CD04.8060303@goop.org> <20080312001040.GA6434@localdomain>
In-Reply-To: <20080312001040.GA6434@localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> Would anyone have objection to have PARAVIRT depend on PCI, since the
> vsmp paravirt bits depend on PCI cfg space to determine if the system is
> vsmp?   If not, this patch would suffice.
>   

NAK.  Xen doesn't depend on PCI at all.   Why not make VSMP depend on 
PCI?  Then you could put something like:

#ifdef CONFIG_X86_VSMP
extern void vsmp_init(void);
extern int is_vsmp_box(void);
#else
static inline void vsmp_init(void)
{
}

static inline int is_vsmp_box(void)
{
	return 0;
}
#endif


in an appropriate header.

Hm, looks like arch/x86/kernel/Makefile should be

obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o


rather than making it depend directly on CONFIG_PARAVIRT.

    J
