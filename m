Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZJFAgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZJFAgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZJFAgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:36:43 -0400
Received: from claw.goop.org ([74.207.240.146]:50064 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbZJFAgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:36:42 -0400
Message-ID: <4ACA90F2.1060909@goop.org>
Date: Mon, 05 Oct 2009 17:36:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Bastian Blank <bastian@waldi.eu.org>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: Disable stack protector for irq
 helper
References: <20091004183013.GA26101@wavehammer.waldi.eu.org>	<4AC92A65.40806@goop.org>	<20091005013517.GA6081@wavehammer.waldi.eu.org>	<4ACA2AFD.4080305@goop.org> <20091005224310.GA32144@wavehammer.waldi.eu.org>
In-Reply-To: <20091005224310.GA32144@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/09 15:43, Bastian Blank wrote:
> On Mon, Oct 05, 2009 at 10:21:01AM -0700, Jeremy Fitzhardinge wrote:
>   
>>> Save all caller-saved registers on x86_32 for the paravirt callee saved
>>> registers.
>>>       
>> That looks better, but it is still overkill.  We only need to save the
>> set of registers the ABI requires the callee to preserve.  What
>> additional register(s) gets clobbered by stack-protector that need to be
>> saved?
>>     
> Well, exactly the two, ecx and edx. eax is still clobbered by the return
> value. Anyway, it works in praxis.

I'm confused.  It already saves ecx, so what else needs saving?

Besides, most of the code in that file isn't used unless you're using a
very old version of Xen; it will generally prefer to use the ones in
xen-asm_X.S.

I have the feeling we haven't really found the root cause of your
problem yet.

Thanks,
    J

