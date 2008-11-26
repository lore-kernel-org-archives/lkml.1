Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYKZCsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYKZCsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYKZCsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:48:06 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:33219 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYKZCsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:48:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D5wh5fFJEGgYQhfQqQ24lOaucAW7SorkzzMMSb3tKqEp2i/GIJj24YhKobsnZNKw5O
         +MpL2VrQ+pPNQTv9xJNSGJGkCL6q81wIUDSG/WZIPmLzIRlEtb8BtP3Z/nfI9/vRxt37
         /mEvBnJL0A4pPzCtnOi9t13mZ4B5Fy90NDuGU=
Message-ID: <807b3a220811251848w384298dp393691173e603fc2@mail.gmail.com>
Date: Wed, 26 Nov 2008 08:18:02 +0530
From: "Nikanth K" <nikanth@gmail.com>
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Subject: Re: [RFC] kreplace: Rebootless kernel updates
Cc: "Nikanth Karthikesan" <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, davem@davemloft.net, contact@ksplice.com,
       jbarnold@ksplice.com, tabbott@ksplice.com, wdaher@ksplice.com,
       andersk@ksplice.com
In-Reply-To: <492AC522.4020202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200811211720.26394.knikanth@suse.de> <4926C838.8080105@redhat.com>
	 <200811241637.33329.knikanth@suse.de> <492AC522.4020202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami

On Mon, Nov 24, 2008 at 8:45 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> Nikanth Karthikesan wrote:
>> On Friday 21 November 2008 20:09:52 Masami Hiramatsu wrote:
>>> Hi Nikanth,
>>>
>>> Nikanth Karthikesan wrote:
>>
>>> Hmm,
>>> Would you like to replace a function to another function?
>>> If so, AFAIK, you can do that with kprobe and below pre_handler.
>>> (see booster enabled path in setup_singlestep())
>>>
>>> pre_handler(...)
>>> {
>>>      reset_current_kprobe(); /* this kprobe doesn't need any more */
>>>      regs->ip = new_function;        /* change IP to new function */
>>>      preempt_enable_no_resched();    /* recover preempt count */
>>>      return 1;       /* No need to setup singlestep */
>>> }
>>>
>>>
>>
>> So, am I seeing worries to enable something, which is already possible, but
>> just not documented?
>
> Actually, you can do this with kprobes, but not documented,
> because the regs->ip setup depends on arch. (above code is only for
> x86/x86-64).
>
> I think it's easier to just provide above pre_handler for each arch than
> jprobe-based kreplace approach.
>

I thought jprobes would provide easy access to function parameters.

Thanks
Nikanth
