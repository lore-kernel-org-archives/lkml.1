Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYJTN2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYJTN2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYJTN2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:28:14 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:52759 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYJTN2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:28:13 -0400
Message-ID: <48FC86B2.8000606@fr.ibm.com>
Date: Mon, 20 Oct 2008 15:25:06 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Louis.Rilling@kerlabs.com
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Andrey Mirkin <major@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1224286383.1848.65.camel@nimitz> <20081020111002.GQ15171@hawkmoon.kerlabs.com>
In-Reply-To: <20081020111002.GQ15171@hawkmoon.kerlabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Louis Rilling wrote:
> On Fri, Oct 17, 2008 at 04:33:03PM -0700, Dave Hansen wrote:
>> On Wed, 2008-09-03 at 14:57 +0400, Andrey Mirkin wrote:
>>> This patchset introduces kernel based checkpointing/restart as it is
>>> implemented in OpenVZ project. This patchset has limited functionality and
>>> are able to checkpoint/restart only single process. Recently Oren Laaden
>>> sent another kernel based implementation of checkpoint/restart. The main
>>> differences between this patchset and Oren's patchset are:
>> Hi Andrey,
>>
>> I'm curious what you want to happen with this patch set.  Is there
>> something specific in Oren's set that deficient which you need
>> implemented?  Are there some technical reasons you prefer this code?
> 
> To be fair, and since (IIRC) the initial intent was to start with OpenVZ's
> approach, shouldn't Oren answer the same questions with respect to Andrey's
> patchset?
> 
> I'm afraid that we are forgetting to take the best from both approaches...

I agree with Louis.

I played with Oren's patchset and tryed to port it on x86_64. I was able 
to sys_checkpoint/sys_restart but if you remove the restoring of the 
general registers, the restart still works. I am not an expert on asm, 
but my hypothesis is when we call sys_checkpoint the registers are saved 
on the stack by the syscall and when we restore the memory of the 
process, we restore the stack and the stacked registers are restored 
when exiting the sys_restart. That make me feel there is an important 
gap between external checkpoint and internal checkpoint.

Dmitry's patchset is nice too, but IMO, it goes too far from what we 
decided to do at the container mini-summit. I think there are a lot of 
design questions to be solved before going further.

IMHO we should look at Dmitry patchset and merge the external checkpoint 
code to Oren's patchset in order to checkpoint *one* process and have 
the process to restart itself. At this point, we can begin to talk about 
the restart itself, shall we have the kernel to fork the processes to be 
restarted ? shall we fork from userspace and implement some mechanism to 
have each processes to restart themselves ? etc...








