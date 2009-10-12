Return-Path: <linux-kernel-owner+w=401wt.eu-S933479AbZJLWUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbZJLWUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbZJLWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:20:53 -0400
Received: from claw.goop.org ([74.207.240.146]:57569 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbZJLWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:20:52 -0400
Message-ID: <4AD3AB9E.5040202@goop.org>
Date: Mon, 12 Oct 2009 15:20:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Bastian Blank <bastian@waldi.eu.org>, Ingo Molnar <mingo@elte.hu>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: Disable stack protector for irq
 helper
References: <4AC92A65.40806@goop.org> <20091005013517.GA6081@wavehammer.waldi.eu.org> <4ACA2AFD.4080305@goop.org> <20091005224310.GA32144@wavehammer.waldi.eu.org> <4ACA90F2.1060909@goop.org> <20091006033050.GA6332@wavehammer.waldi.eu.org> <4ACB93F8.5010900@goop.org> <20091007163521.GA17998@wavehammer.waldi.eu.org> <4ACD3346.3010307@goop.org> <20091012205208.GE17163@elte.hu> <20091012211258.GA21213@wavehammer.waldi.eu.org>
In-Reply-To: <20091012211258.GA21213@wavehammer.waldi.eu.org>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/09 14:12, Bastian Blank wrote:
> On Mon, Oct 12, 2009 at 10:52:08PM +0200, Ingo Molnar wrote:
>   
>> ping - any update about this fix? Since it fixes a real crash it would 
>> be nice to fix this for .32.
>>     
> It works nicely.
>
> But IMHO this whole infrastructure should go for now, at least until gcc
> is able to produce functions with this call convention on its own. Or it
> needs to be restricted to only assembler functions. The other users of
> this may only work because the stack protector is already disabled for
> arch/x86/xen/mmu.o.
>   

No, the infrastructure is fine and completely compliant with the ABI
(which doesn't change with stackprotector).  But there were a couple of
interrupt-related calls which didn't use the infrastructure properly,
and failed to preserve edx properly; we'd gotten away with it until now
because the called functions were very simple and didn't end up using
edx - until stackprotector.

The fix is to use the infrastructure consistently.

I'll put together a suitable patch.

    J
