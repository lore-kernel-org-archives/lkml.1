Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbXGIGqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbXGIGqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 02:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXGIGq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 02:46:28 -0400
Received: from il.qumranet.com ([82.166.9.18]:35794 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXGIGq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 02:46:28 -0400
Message-ID: <4691D9C1.4050309@qumranet.com>
Date: Mon, 09 Jul 2007 09:46:25 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, KVM <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
References: <11838956891287-git-send-email-avi@qumranet.com>	<11838956893094-git-send-email-avi@qumranet.com> <p73lkdqzpdm.fsf@bingen.suse.de>
In-Reply-To: <p73lkdqzpdm.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Mon, 09 Jul 2007 09:46:26 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc list restored]

Andi Kleen wrote:
>> This defines on_cpu() which is similar to smp_call_function_single()
>> except that it works if cpu happens to be the current cpu.  Can also be
>> seen as a complement to on_each_cpu() (which also doesn't treat the
>> current cpu specially).
>>     
>
> I think it would be better to fix smp_call_function_single to just
> handle this case transparently. There aren't that many callers yet because it is
> fairly new.
>   

Well, smp_call_function_single() is arch specific whereas on_cpu() is
generic code.  Perhaps rename smp_call_function_single() to
__smp_call_function_single() and on_cpu() to smp_call_function_single()?

I dislike the loss of symmetry though.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

