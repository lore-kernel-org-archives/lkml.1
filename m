Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYKUOmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYKUOmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 09:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYKUOlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 09:41:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40636 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbYKUOlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 09:41:50 -0500
Message-ID: <4926C838.8080105@redhat.com>
Date: Fri, 21 Nov 2008 09:39:52 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: linux-kernel@vger.kernel.org, ananth@in.ibm.com, davem@davemloft.net,
       contact@ksplice.com, jbarnold@ksplice.com, tabbott@ksplice.com,
       wdaher@ksplice.com, andersk@ksplice.com
Subject: Re: [RFC] kreplace: Rebootless kernel updates
References: <200811211720.26394.knikanth@suse.de>
In-Reply-To: <200811211720.26394.knikanth@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikanth,

Nikanth Karthikesan wrote:
> This RFC patch adds support for limited form of rebootless kernel patching 
> even without building the entire kernel.
> 
> When looking for a shortcut to avoid the rebuild/reboot cycle when hacking the  
> kernel - the ksplice[1] was posted. This patch extends kprobes to do something 
> similar, which would require even lesser time to _experiment_ with the running 
> kernel. 
> 
> This small patch extends jprobes so that the jprobe's handler is executed but 
> skips executing the actual function. But this has its own limitations such as 
> Cannot access symbols not exported for modules (ofcourse hacks like 
> pointers[2] can be used.), problems related to return values[3], etc... This 
> is currently a x86_64 only _hack_.

Hmm,
Would you like to replace a function to another function?
If so, AFAIK, you can do that with kprobe and below pre_handler.
(see booster enabled path in setup_singlestep())

pre_handler(...)
{
	reset_current_kprobe();	/* this kprobe doesn't need any more */
	regs->ip = new_function;	/* change IP to new function */
	preempt_enable_no_resched();	/* recover preempt count */
	return 1;	/* No need to setup singlestep */
}

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

