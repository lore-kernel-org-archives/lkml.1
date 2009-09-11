Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbZIKKdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbZIKKdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 06:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbZIKKdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 06:33:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52847 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZIKKdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 06:33:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [RFC][v6][PATCH 8/9]: Define clone_with_pids() syscall
Date: Fri, 11 Sep 2009 12:31:29 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
References: <20090910060627.GA24343@us.ibm.com> <200909100931.25585.arnd@arndb.de> <20090910212837.GA31459@us.ibm.com>
In-Reply-To: <20090910212837.GA31459@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909111231.30495.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/2lXSpPWZo2VzRZvahXEH4Rjwp0XwPnlshi4k
 CVIpvh9Z1F7f8nHqVWxEDreZ7l6Vmi9kVB5mNEV8s5gi+xlgM2
 lPxaGPIEqAS1o8TEmo1rA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 September 2009, Sukadev Bhattiprolu wrote:
> Since this is a variant of clone() and clone is listed as a PTREGSCALL(),
> I pass in the pt_regs.
> 
> arch/x86/kernel/entry_32.S lists clone() under this comment:
> 
> /*
>  * System calls that need a pt_regs pointer.
>  */
> 
> Is there a guideline on what system calls use/need pt_regs ?

You need pt_regs if you access any registers from the user task
other than the argument registers. In case of clone(), this is
the user stack pointer.

The user_stack_pointer() function is relatively new, before this
you couldn't get the stack pointer out of pt_regs in a generic
way.

	Arnd <><
