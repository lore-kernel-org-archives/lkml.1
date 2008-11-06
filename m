Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbYKFSZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbYKFSZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 13:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYKFSYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 13:24:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59928 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbYKFSYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 13:24:51 -0500
Message-ID: <49133665.8090701@redhat.com>
Date: Thu, 06 Nov 2008 12:24:37 -0600
From: David Smith <dsmith@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 15/21] ptrace changes
References: <20081001083317.782967473@de.ibm.com>	 <20081001084129.042880937@de.ibm.com>  <490F317C.9040603@redhat.com> <1225885284.17430.7.camel@localhost>
In-Reply-To: <1225885284.17430.7.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> On Mon, 2008-11-03 at 11:14 -0600, David Smith wrote: 
> 
>> Is this correct, or should the 1st syscall argument be found in
>> regs->orig_gpr2 by syscall_get_arguments()/syscall_set_arguments()?
> 
> The question is when do syscall_get_arguments and syscall_set_arguments
> functions get called? If they are called on a call chain that started
> from do_syscall_trace_enter then we'd have to use orig_gpr2 instead of
> gprs[2] but if the functions are not called via do_syscall_trace_enter
> the first argument is located in grprs[2]. As far as I can see the sole
> user of syscall_get_arguments is collect_syscall which is used to get
> the registers of a blocked process. In this case the kernel call chain
> does not include do_syscall_trace_enter, therefore the first argument is
> in gprs[2], no?

But, collect_syscall() also calls syscall_get_nr():

	*callno = syscall_get_nr(target, regs);
	if (*callno != -1L && maxargs > 0)
		syscall_get_arguments(target, regs, 0, maxargs, args);

Both syscall_get_nr() *and* syscall_get_arguments() returning gprs[2]
can't be right, can it?

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)

