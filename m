Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbYIUNBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbYIUNBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 09:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYIUNBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 09:01:04 -0400
Received: from main.gmane.org ([80.91.229.2]:39845 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbYIUNBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 09:01:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: David W Studeman <avionicsdv@aim.com>
Subject: Re: Keyboard Jammed error patch 2.4.35-pre4
Date: Sun, 21 Sep 2008 06:00:50 -0700
Message-ID: <gb5gi2$l36$1@ger.gmane.org>
References: <g6jqud$t5e$1@ger.gmane.org> <20080729051558.GH29189@1wt.eu> <489016AB.6050309@aim.com> <20080730075101.GA31668@1wt.eu> <489044C8.7090006@aim.com> <20080730123839.GA2397@1wt.eu>
Reply-To: avionicsdv@aim.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-71-112-171-94.sttlwa.dsl-w.verizon.net
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:

> On Wed, Jul 30, 2008 at 03:39:04AM -0700, David W Studeman wrote:
>> >This was the important part. Did you fix it by hand ? If not, it would
>> >explain why it did not change the behaviour.
>> >
>>  It didn't change the behaviour because it would not apply cleanly,
>> kernel compilation stopped there.
> 
> Ah OK, so if you applied half of the patch, it's expected that the fix is
> not applied !
> 
>> A raq/qube3, raq4, raq550, and xtr are all x86 based
> 
> OK, that's what I wanted to know, because I needed to understand whether
> the compiled code was in the i386 directory or in another one.
> 
>> but they do not use
>> a typical bios and a bootloader to start the boot process but that part
>> is not important here.
> 
> that's what I understood.
> 
>> When I made the regression patch, I simply diffed
>> the dmi scan and keyboard drivers between the two kernels. The stock
>> 2.4.36.6 kernel cannot be compiled for x86 with no keyboard and vt
>> support
> 
> Why? I have it running on several machines! What error do you get ? Or
> perhaps it's just a matter of not finding the appropriate configuration
> (which is not obvious, I agree) ?
> 
>> and I need no dummy driver even though it would not compile by
>> choosing the dummy driver by itself either.
> 
> Why would it not compile ?
> 
> I'm sorry, but you keep saying that solution XXX would not work but you
> don't indicate what issue you encounter when you try it. If there are
> problems, obviously they need to be fixed, but I cannot fix problems
> based on suppositions.
> 
>> Regression patching to
>> 2.4.34 restored the ability to compile without keyboard and vt support.
>> This is what it took:
> 
> I'm well aware of the patch you reverted. But in my opinion, you fix
> symptoms and not the cause. This patch fixed a problem. Reverting it
> causes either :
>   - kbd_controller_present being uncondtionally defined to 1, meaning
>     it would not change anything for you
> 
>   - kbd_controller_present being defined to zero by some obscure other
>     configuration that we just need to find out. However, the last patch
>     I sent to you would have taken care of it, had it applied correctly
>     (please apply it by hand in this case, it's just a matter of changing
>     one macro name in the "if").
> 
> Thanks,
> Willy


Ok, I finally applied the patch manually to 2.4.36.7 and then made my own
diff from that. Your patch would likely have applied if I increased the
fuzz factor as it was merely off by a number of lines. When trying to
compile with no keyboard or VT support, I still get this error:

arch/i386/kernel/kernel.o(.text.init+0x33e6): In function
`disable_console_keyboard':
: undefined reference to `keyboard_controller_present'
make: *** [vmlinux] Error 1

When I did a regression patch I also did the arch/i386/kernel/dmi_scan.c
since some of the changes made back in 2.4.35 to this file are where the
error comes from in the above error. DMI blacklisting will NOT work with
Cobalt hardware as there is no dmi present to blacklist. Also note that the
above error does not occur with a normal pc configuration where you include
keyboard support and VT support but once you try to make a kernel without
keyboard and VT support for embedded devices, dmi_scan.c breaks the build. 


Dave

