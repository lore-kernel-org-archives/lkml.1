Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbXC2Pmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbXC2Pmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 11:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbXC2Pmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 11:42:50 -0400
Received: from ananas2.netvision.net.il ([199.203.100.203]:38027 "EHLO
	ntx.netvision.net.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753785AbXC2Pmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 11:42:49 -0400
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: cifs causes BUG: soft lockup detected on CPU
Date: Thu, 29 Mar 2007 17:42:39 +0200
Message-ID: <58D14E53A4F69C4EAF4D29171C447CC4011AC794@NTX-CL.forest.netvision.net.il>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-topic: cifs causes BUG: soft lockup detected on CPU
Thread-index: AcdyE9BRYObgiYHnT42SVAMZyUtyHQABQG3Q
From: "Valentin Zaharov" <karlos_@netvision.net.il>
To: "Steven French" <sfrench@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot, I will try to update to latest kernel version and see if
it helps.


-----Original Message-----
From: Steven French [mailto:sfrench@us.ibm.com] 
Sent: Thursday, March 29, 2007 5:06 PM
To: Andrew Morton
Cc: Valentin Zaharov; linux-kernel@vger.kernel.org
Subject: Re: cifs causes BUG: soft lockup detected on CPU

This should be fixed in 2.6.21 as of 2/26.  The fix was
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commi
t;h=3677db10a635a39f63ea509f8f0056d95589ff90


Steve French
Senior Software Engineer
Linux Technology Center - IBM Austin
phone: 512-838-2294
email: sfrench at-sign us dot ibm dot com

Andrew Morton <akpm@linux-foundation.org> wrote on 03/29/2007 03:54:57
AM:

> On Wed, 28 Mar 2007 20:35:55 +0200 "Valentin Zaharov" 
> <karlos_@netvision.net.il> wrote:
> 
> > Hi,
> > 
> > We have continous problem with server freezes. We are using cifs 
mounts
> > on apache powered web servers with content located on Win2k3 server.
> > Servers freeze from time to time, producing following error just 
before
> > freeze:
> > 
> > Mar 26 21:50:37 UFR2 kernel:  CIFS VFS: cifs_strtoUCS: char2uni 
returned
> > -22 Mar 26 21:51:45 UFR2 last message repeated 55 times Mar 26 
21:52:49
> > UFR2 last message repeated 30 times Mar 26 21:54:16 UFR2 last
message
> > repeated 10 times Mar 26 21:56:13 UFR2 last message repeated 20
times
> > Mar 26 21:58:34 UFR2 last message repeated 75 times Mar 26 21:59:43 
UFR2
> > last message repeated 30 times Mar 26 22:01:02 UFR2 last message
> > repeated 30 times Mar 26 22:02:04 UFR2 last message repeated 30
times
> > Mar 26 22:03:08 UFR2 last message repeated 50 times Mar 26 22:04:27 
UFR2
> > last message repeated 10 times Mar 26 22:05:59 UFR2 last message
> > repeated 20 times Mar 26 22:07:10 UFR2 last message repeated 20
times
> > Mar 26 22:29:00 UFR2 last message repeated 64 times Mar 27 00:47:40 
UFR2
> > last message repeated 15 times Mar 27 01:42:41 UFR2 last message
> > repeated 95 times Mar 27 02:15:57 UFR2 last message repeated 90
times
> > Mar 27 02:27:13 UFR2 last message repeated 45 times Mar 27 03:14:08 
UFR2
> > last message repeated 95 times Mar 27 04:26:10 UFR2 last message
> > repeated 2 times Mar 27 06:11:35 UFR2 last message repeated 45 times

Mar
> > 27 06:20:20 UFR2 last message repeated 15 times Mar 27 06:20:20 UFR2
> > last message repeated 12 times Mar 27 06:27:53 UFR2 kernel: BUG:
soft
> > lockup detected on CPU#3!
> > Mar 27 06:27:53 UFR2 kernel:  [<c0134b57>] softlockup_tick+0x9e/0xac

Mar
> > 27 06:27:53 UFR2 kernel:  [<c0121440>]
update_process_times+0x3b/0x5e
> > Mar 27 06:27:53 UFR2 kernel:  [<c010d885>]
> > smp_apic_timer_interrupt+0x6c/0x7a
> > Mar 27 06:27:53 UFR2 kernel:  [<c01032ec>]
> > apic_timer_interrupt+0x28/0x30 Mar 27 06:27:53 UFR2 kernel:
> > [<c0153d75>] generic_fillattr+0x75/0xa8 Mar 27 06:27:53 UFR2 kernel:
> > [<f8e78ed2>] cifs_getattr+0x1e/0x2b [cifs] Mar 27 06:27:53 UFR2 
kernel:
> > [<f8e78eb4>] cifs_getattr+0x0/0x2b [cifs] Mar 27 06:27:53 UFR2
kernel:
> > [<c0153dc9>] vfs_getattr+0x21/0x30 Mar 27 06:27:53 UFR2 kernel:
> > [<c0153e93>] vfs_fstat+0x22/0x31 Mar 27 06:27:53 UFR2 kernel:
> > [<c015443a>] sys_fstat64+0xf/0x23 Mar 27 06:27:53 UFR2 kernel:
> > [<c0150fc5>] sys_open+0x1a/0x1c Mar 27 06:27:53 UFR2 kernel:
> > [<c0102820>] sysenter_past_esp+0x5d/0x81 Mar 27 06:27:53 UFR2
kernel:
> > [<c0310033>] xdr_xcode_array2+0x307/0x506 Mar 27 06:27:53 UFR2
kernel:
> 
> You didn't tell us what kernel version you're running.
> 
> Hanging in generic_fillattr: i_size_read() got stuck.  This is because

CIFS
> doesn't correctly hold i_mutex across i_size_write().
> 
> Steve, where are we up to with the fixes for that?

