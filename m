Return-Path: <linux-kernel-owner+w=401wt.eu-S1751634AbYCJOMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbYCJOMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYCJOMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:12:40 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:16610 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYCJOMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:12:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=wwh2kElPJCBBnc8+QSyHKmyiqvu0kGuPRiQhvrsIQLNTaiqS/ehCuqaG6tfX7UI9l3AcLRtBbMNfSP4RhO0mX3sPNeSRpxMwyThHMt0M7uHm9WMCFKv/OoBn70Qx07oOfFxudxJCPRwpBzTAkxtL+7zDootT48VUndqs7ME4o/M=
Message-ID: <47D541C2.5070804@gmail.com>
Date: Mon, 10 Mar 2008 10:12:18 -0400
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, suresh.b.siddha@intel.com, yi.y.yang@intel.com,
       tglx@linutronix.de, akpm@linux-foundation.org, rjw@sisk.pl,
       oleg@sign.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adjust root-domain->online span in response to hotplugevent
References: <20080308015045.GB15909@linux-os.sc.intel.com>	 <20080308050627.4831.87630.stgit@novell1.haskins.net>	 <20080308084118.GA24552@elte.hu> <47D28BAC.BA47.005A.0@novell.com> <b647ffbd0803081631y282cfe1blb7343eb1c979b871@mail.gmail.com>
In-Reply-To: <b647ffbd0803081631y282cfe1blb7343eb1c979b871@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> On 08/03/2008, Gregory Haskins <ghaskins@novell.com> wrote:
> 
> I guess, it's in arch-specific code. e.g. for x86-64,
> 
> down:
> 
> kernel/cpu.c :: _cpu_down -> take_cpu_down() -> __cpu_disable() [
> arch/x86/kernel/smpboot_64.c ] -> cpu_clear(cpu, cpu_online_map)
> 
> up:
> 
> kernel/cpu.c :: _cpu_up() -> __cpu_up [ arch/x86/kernel/smpboot_64.c ]
> -> do_boot_cpu() -> start_secondary() [ runs on a to-be-online cpu ]
> -> cpu_set(smp_processor_id(), cpu_online_map)

Thanks Dmitry!  Your tip helped me to figure out what the real solution 
should be.

Regards,
-Greg
