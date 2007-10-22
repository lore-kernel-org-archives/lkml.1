Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbXJVM3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbXJVM3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbXJVM3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:29:23 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:60715 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbXJVM3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=CA+KJuII55wbfRlxUVbvPlNhKuyBdLHZSCERXEqag/H7ae4fSa8nJw2uD7Aaajoai3TC4EEHDajFMkhwKnAJPh9ztAlEeQwdHg9T9pARUs1aCj2OmC0Wx95Y4RFh62ioE3Nj7bDZxsxiI3EFd38hZwTZ9PWBk8eIRceLDU4QEcM=
Date: Mon, 22 Oct 2007 20:25:04 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Nix <nix@esperi.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Ingo Molar <mingo@elte.hu>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071022122504.GL2998@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking> <20071022113600.GA8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071022113600.GA8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 12:36:00PM +0100, Al Viro wrote:
>On Mon, Oct 22, 2007 at 03:48:23PM +0800, WANG Cong wrote:
>> I just followed what Sam told me, errors are much fewer this time,
>> but still exist. Error messages are:
>> 
>>   CC      arch/um/kernel/syscall.o
>>   CC      arch/um/kernel/sysrq.o
>> arch/um/kernel/sysrq.c: In function ???show_stack???:
>> arch/um/kernel/sysrq.c:63: error: ???UESP??? undeclared (first use in this function)
>> arch/um/kernel/sysrq.c:63: error: (Each undeclared identifier is reported only once
>> arch/um/kernel/sysrq.c:63: error: for each function it appears in.)
>> make[1]: *** [arch/um/kernel/sysrq.o] Error 1
>> make: *** [arch/um/kernel] Error 2
>> 
>> Or I missed something again?
>> 
>> And I use `make defconfig ARCH=um' to generate .config, my tree
>> is 2.6.23-git16 (Al, is this OK?).
>
>Now apply the patch upthread, it should've fixed that one (and yes, you
>are down to the stuff this patch is supposed to fix - and does so here).

Yes, this one is fixed. Thanks for your patch.

But another one comes out. ;(

  CC      kernel/sched.o
kernel/sched.c:3902: error: conflicting types for ‘wait_for_completion_interruptible’
include/linux/completion.h:46: error: previous declaration of ‘wait_for_completion_interruptible’ was here
kernel/sched.c:3908: error: conflicting types for ‘wait_for_completion_interruptible’
include/linux/completion.h:46: error: previous declaration of ‘wait_for_completion_interruptible’ was here
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

CC: Ingo Molar <mingo@elte.hu>

-- 
May the Source Be With You.
