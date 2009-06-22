Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbZFVRmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbZFVRmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZFVRmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:42:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZFVRmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:42:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: I.1 - System calls - ioctl
Date: Mon, 22 Jun 2009 19:41:48 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, eranian@gmail.com,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       "perfmon2-devel" <perfmon2-devel@lists.sourceforge.net>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622125837.GA9429@infradead.org> <20090622135611.GA5329@elte.hu>
In-Reply-To: <20090622135611.GA5329@elte.hu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906221941.49470.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18up1kZGY1TFtsAk6pXKtKPuQr8Ohd0vh9HG78
 1dTJvhqXs4hC0gs1AndoUdBBr8QlQQyCf275KqWvVIdyu0D8BM
 7XXMuJphCTL7tL1dTZ1Ag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Ingo Molnar wrote:
> There is another, more theoretical argument in favor of 
> sys_perf_counter_chattr(): it is quite conceivable that as usage of 
> perfcounters expands we want to change more and more attributes. So 
> even though right now the ioctl just about manages to serve this 
> role, it would be more future-proof to use sys_perf_counter_chattr() 
> and deprecate the ioctl() straight away - to not even leave a 
> chance for some ioctl crap to seep into the API.
> 
> So ... we are on two minds about this, and if people dont mind a 
> second syscall entry, we are glad to add it.

I think adding one or more system calls is definitely worth it
if that means getting rid of the ioctl interface here. While I
don't generally mind adding ioctl calls, I would much prefer to
restrict their use to device files, sockets and to the existing
cases for regular files.

Conceptually, ioctl is a different class of interface from the
'new system call' case, in a number of ways. For new subsystems
I would just never mix them by allowing ioctl on something that
was not returned by open() or socket().

	Arnd <><
