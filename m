Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYJ0Qij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYJ0Qij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYJ0QiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:38:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51363 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYJ0QiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:38:17 -0400
Message-ID: <4905EE6B.9070000@redhat.com>
Date: Mon, 27 Oct 2008 18:38:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Eric Lacombe <goretux@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [x86] - technical questions about HV implementation on Intel
 VT
References: <200810201927.33580.goretux@gmail.com> <48FD9B54.4040109@redhat.com> <200810271529.26821.goretux@gmail.com>
In-Reply-To: <200810271529.26821.goretux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> Hi,
>
> Thanks for your answer.
> I will eventually add a netconsole, but for now, I find how to bypass my 
> problem (getting debug information).
>
> However I come with a new question, related to an unexpected VM-exit.
> The scenario is as follows:
> 1. some setup occur
> 2. vmlaunch is executed by a function F, so the guest is launched. This guest 
> (as I explained in my previous mail) executes the end of the function F.
> 3. The end of F, do some "printk" then return to the module init function.
>
> The problem is that I get a VM-exit during the step 3. In fact after the 
> first "printk", a vm-exit occurs with exit_reason=2 (triple-fault).
>
> Do you have an idea of what could be the cause of this vm-exit?
>   

Almost any emulation error can cause this.  Something goes wrong, an 
exception is raised, can't be handled due to the same problem (or maybe 
another one), triple fault.

You need to print out the entire contents of the vmcs before the last 
entry and check it out carefully.

-- 
error compiling committee.c: too many arguments to function

