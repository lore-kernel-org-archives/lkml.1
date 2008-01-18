Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbYARDl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbYARDl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 22:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYARDll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 22:41:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37981 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYARDlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 22:41:40 -0500
Message-ID: <47901E89.4060001@zytor.com>
Date: Thu, 17 Jan 2008 22:35:37 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Use v8086_mode helper, trivial unification
References: <1200611078.5724.46.camel@brick>	<478FDE76.3070309@zytor.com>	 <1200612389.5724.63.camel@brick>	<478FF9F3.9030604@zytor.com>	 <1200618952.5724.85.camel@brick>	 <20080118013712.4090526FA0B@magilla.localdomain>	 <479002B6.9030607@zytor.com> <1200622862.5724.106.camel@brick>
In-Reply-To: <1200622862.5724.106.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> 
> What do you think of:
> 
> /*
>  * (unsigned long)regs looks strange, but it's correct for x86_32.  x86_32 CPUs
>  * don't save the ss and esp registers if the CPU is already in kernel mode
>  * when it traps.  So &regs happens to be esp.  Valid only for kernel-mode
>  * pt_regs.
>  */
> static inline unsigned long stack_pointer(struct pt_regs *regs)
> {
> #ifdef CONFIG_X86_32
> 	return (unsigned long)regs;
> #else
> 	return regs->sp;
> #endif
> }
> 

Please highlight the last sentence better.  That's a user restriction 
and a highly important one.

	-hpa
