Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXCGOMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXCGOMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965514AbXCGOMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:12:43 -0500
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:32030 "EHLO
	dgate1.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965513AbXCGOMm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:12:42 -0500
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 09:12:42 EST
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=f+blfsIXLWUryoH4dbiCcp68dvGLcEbMX9+rluO9yElxtVzYFTkajrWbt3fJMz3qUSLiGsIPh6lLbXQpvcv5L2wtoYNnKhTj/3n8xa8A2c5AoTg3OWLa88CNuGyzWShf;
X-SBRSScore: None
X-IronPort-AV: i="4.14,259,1170630000"; 
   d="scan'208"; a="66819328:sNHT29598192"
To: linux-kernel@vger.kernel.org
Subject: How do I analyze a soft lockup? 
Organization: Fujitsu Siemens Computers VP BC E SW OS
From: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
Date: Wed, 07 Mar 2007 15:02:15 +0100
Message-ID: <87k5xt40ew.fsf@ABG3595C.abg.fsc.net>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Environment:

Kernel is 2.6.16.27, arch x86_64 on a Dual Core AMD64 machine with
4 GB of RAM. Also involved is an Areca 1100 SATA RAID controller
with the drives from the Tekram website. 

Problem: 

We get customer reports that a system stops with the following kernel
messages (as they are submitted to us, we're not able yet to reproduce
the problem in our laboratory :-( )

------------------8<-snip--------------------------------------------

BUG: soft lockup detected on CPU#1!

Call Trace:
  <IRQ>  [<ffffffff8024cd64>] softlockup_tick+0xd3/0xe5
  [<ffffffff8023700d>] update_process_times+0x42/0x68
  [<ffffffff80215925>] smp_local_timer_interrupt+0x31/0x54
  [<ffffffff80215997>] smp_apic_timer_interrupt+0x4f/0x66
  [<ffffffff8020a266>] apic_timer_interrupt+0x66/0x70
  <EOI>  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff8025d643>] __handle_mm_fault+0x256/0x2d9
  [<ffffffff8025d640>] __handle_mm_fault+0x253/0x2d9
  [<ffffffff8021d5c2>] do_page_fault+0x23f/0x572
  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff805c27dd>] error_exit+0x0/0x84
  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff80373550>] __put_user_4+0x20/0x30
  [<ffffffff802272cb>] schedule_tail+0x81/0x86
  [<ffffffff8020958c>] ret_from_fork+0xc/0x25

BUG: soft lockup detected on CPU#1!

Call Trace:
  <IRQ>  [<ffffffff8024cd64>] softlockup_tick+0xd3/0xe5
  [<ffffffff8023700d>] update_process_times+0x42/0x68
  [<ffffffff80215925>] smp_local_timer_interrupt+0x31/0x54
  [<ffffffff80215997>] smp_apic_timer_interrupt+0x4f/0x66
  [<ffffffff8020a266>] apic_timer_interrupt+0x66/0x70
  <EOI>  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff8025d643>] __handle_mm_fault+0x256/0x2d9
  [<ffffffff8025d640>] __handle_mm_fault+0x253/0x2d9
  [<ffffffff8021d5c2>] do_page_fault+0x23f/0x572
  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff8021d8f2>] do_page_fault+0x56f/0x572
  [<ffffffff805c27dd>] error_exit+0x0/0x84
  [<ffffffff8020969e>] system_call+0x7e/0x83
  [<ffffffff80373550>] __put_user_4+0x20/0x30
  [<ffffffff802272cb>] schedule_tail+0x81/0x86
  [<ffffffff8020958c>] ret_from_fork+0xc/0x25

----------------8<-snip------------------------------------------

The first thing that makes me very suspicious or curious is that the
call stack shows "__handle_mm_fault" twice, but looking at the source
of that function I don't see any recursion that would explain the 
double line. 

Is there any idea where I can start digging around? 

TIA
Rainer
-- 
Rainer König, Diplom-Infomatiker (FH), Augsubrg, Germany
