Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbYJ0Spw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbYJ0Spw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYJ0Spn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:45:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37973 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751912AbYJ0Spn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:45:43 -0400
Message-ID: <49060C9A.5060807@sgi.com>
Date: Mon, 27 Oct 2008 11:46:50 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jack Steiner <steiner@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] SGI x86 UV: Use raw_smp_processor_id
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org> <490249CF.2080308@sgi.com> <49024B1D.1050407@sgi.com> <20081027114205.GB5631@elte.hu> <4905D568.20701@sgi.com> <20081027180616.GG3046@elte.hu>
In-Reply-To: <20081027180616.GG3046@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: SGI x86 UV: Use raw_smp_processor_id

> one small comment:
> 
>> +	/* is this cpu idle? */
>> +	if (idle_cpu(smp_processor_id()))
>>  		bits &= ~SCIR_CPU_ACTIVITY;
> 
> were you ever to run an -rt kernel on that hardware, this would 
> produce a warning. raw_smp_processor_id() would be more appropriate i 
> guess.

Thanks for the heads up!  Yes, -rt is supported.  Might as well avoid that
problem now.

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/genx2apic_uv_x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- test-tip-latest.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ test-tip-latest/arch/x86/kernel/genx2apic_uv_x.c
@@ -372,7 +372,7 @@ static void uv_heartbeat(unsigned long i
 	bits ^= SCIR_CPU_HEARTBEAT;
 
 	/* is this cpu idle? */
-	if (idle_cpu(smp_processor_id()))
+	if (idle_cpu(raw_smp_processor_id()))
 		bits &= ~SCIR_CPU_ACTIVITY;
 	else
 		bits |= SCIR_CPU_ACTIVITY;
