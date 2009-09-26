Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZIZAWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZIZAWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 20:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZIZAWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 20:22:25 -0400
Received: from claw.goop.org ([74.207.240.146]:58147 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbZIZAWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 20:22:24 -0400
Message-ID: <4ABD5EC3.5040204@goop.org>
Date: Fri, 25 Sep 2009 17:22:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: unify sys_iopl
References: <4ABD3EC2.1020104@goop.org>	 <73c1f2160909251556g40f3c5b1o1c29b7f012912873@mail.gmail.com>	 <4ABD50A5.5000309@goop.org> <73c1f2160909251654v1c9f8eb9k9211f1e0c5e15f67@mail.gmail.com>
In-Reply-To: <73c1f2160909251654v1c9f8eb9k9211f1e0c5e15f67@mail.gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/09 16:54, Brian Gerst wrote:
> Using task_pt_regs is less effecient than getting the pointer directly
> from the syscall entry code.

(really not an issue in this case)

>   On 32-bit it probably doesn't matter too
> much, but on 64-bit, you still need the special stub code in
> entry_64.S to put the full pt_regs struct on the stack.  Changing the
> calling conventions should be a seperate patch, and should be done for
> all pt_regs-using syscalls.
>   

iopl only really cares about [er]flags, so it probably doesn't need a
full ptregs structure anyway.  But I'm not sure what changes you'd
consider for the rest of the ptregs calls; sigaltstack probably doesn't
need full ptregs either (it just updates [er]sp I think), but fork/clone
definitely do.

    J
