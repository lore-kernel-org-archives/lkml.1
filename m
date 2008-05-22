Return-Path: <linux-kernel-owner+w=401wt.eu-S1763234AbYEVWXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763234AbYEVWXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbYEVWW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:22:59 -0400
Received: from aun.it.uu.se ([130.238.12.36]:48408 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337AbYEVWW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:22:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18485.61966.193804.314820@harpo.it.uu.se>
Date: Fri, 23 May 2008 00:22:06 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
In-Reply-To: <4835E6F5.5010801@zytor.com>
References: <20080520015723.GD30034@linux-os.sc.intel.com>
	<4832A173.6020203@firstfloor.org>
	<18482.53246.642835.894623@harpo.it.uu.se>
	<4832E705.2010900@zytor.com>
	<18482.60491.764019.292031@harpo.it.uu.se>
	<20080520175325.GE30034@linux-os.sc.intel.com>
	<4834BE39.2000904@zytor.com>
	<18485.13663.51624.694435@harpo.it.uu.se>
	<20080522205619.GB7998@linux-os.sc.intel.com>
	<4835DF64.6080104@zytor.com>
	<20080522212920.GC7998@linux-os.sc.intel.com>
	<4835E6F5.5010801@zytor.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin writes:
 > > But user can potentially change the _fpstate pointer in sigcontext struct.
 > 
 > If so, they get what they bargained for... I am not even sure the kernel 
 > will successfully clean up the stack frame if they do that.

Why would that be a problem? The stack is defined by the user's SP,
which is in the integer state part of the sigframe. We do a sigreturn(),
reload SP/PC/etc, and off we go. Where fpstate pointed to doesn't matter,
as long as it was NULL or a valid fpstate image.
