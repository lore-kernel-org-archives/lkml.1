Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZIKLNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZIKLNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZIKLNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:13:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52739 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZIKLNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:13:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: Re: [RFC][v6][PATCH 8/9]: Define clone_with_pids() syscall
Date: Fri, 11 Sep 2009 13:12:27 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
References: <20090910060627.GA24343@us.ibm.com> <200909111231.30495.arnd@arndb.de> <20090911110056.GA12824@hawkmoon.kerlabs.com>
In-Reply-To: <20090911110056.GA12824@hawkmoon.kerlabs.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909111312.27497.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19uVaU2L6mXKW/X9ePwBa8MXEHPazgHpwZNNCL
 Aik/8C3EKUvDUOR8Z7HqTeImWaonH3rTuK5AkMYk9dPS26bCzs
 6Bryuaw7OXsruZ+TjpIpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 September 2009, Louis Rilling wrote:
> On 11/09/09 12:31 +0200, Arnd Bergmann wrote:
> > On Thursday 10 September 2009, Sukadev Bhattiprolu wrote:
> > > Since this is a variant of clone() and clone is listed as a PTREGSCALL(),
> > > I pass in the pt_regs.
> > > 
> > > arch/x86/kernel/entry_32.S lists clone() under this comment:
> > > 
> > > /*
> > >  * System calls that need a pt_regs pointer.
> > >  */
> > > 
> > > Is there a guideline on what system calls use/need pt_regs ?
> > 
> > You need pt_regs if you access any registers from the user task
> > other than the argument registers. In case of clone(), this is
> > the user stack pointer.
> 
> AFAICS clone() actually needs all registers (see x86 copy_thread() for
> instance). Any variant of clone() will have this requirement.

Right, but that part (do_fork) is already handled in common code, which
function calls into architecture specific code.

The point I was making is that the sys_clone() and sys_clone_with_pids()
functions themselves only access the argument registers, the stack
pointer and pass those down to do_fork, along with pt_regs.

	Arnd <><
