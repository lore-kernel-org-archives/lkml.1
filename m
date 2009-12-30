Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZL3Jku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZL3Jku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZL3Jkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:40:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZL3Jkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:40:49 -0500
Message-ID: <4B3B201B.1090100@redhat.com>
Date: Wed, 30 Dec 2009 11:40:43 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: BUG at kvm_main.c: invalid opcode 0000 [#1] SMP
References: <4B3B1895.1070007@pardus.org.tr>
In-Reply-To: <4B3B1895.1070007@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2009 11:08 AM, Ozan Çağlayan wrote:
> Hi,
>
> kvm-kmod 2.6.32 compiled and loaded against 2.6.30.9 gives the following trace after modprobe:
>
> [   36.130555] Call Trace:
> [   36.130857]  [<f88d339e>] ? vmx_init+0x1c5/0x20a [kvm_intel]
> [   36.131585]  [<f88d31d9>] ? vmx_init+0x0/0x20a [kvm_intel]
> [   36.132290]  [<c0101139>] ? do_one_initcall+0x4c/0x13a
> [   36.132951]  [<c01531f9>] ? sys_init_module+0x87/0x18b
> [   36.133613]  [<c01031d4>] ? sysenter_do_call+0x12/0x28
> [   36.134272] Code: c3 55 31 c0 89 e5 c7 42 40 f8 6c 86 f8 5d c3 55 31 c0 89 e5 c7 42 40 7c 6c 86 f8 5d c3 80 3d 1c 82 86 f8 00 55 89 e5 74 02 eb fe<0f>  0b eb fe 55 b9 07 00 00 00 89 e5 57 89 c7 31 c0 f3 ab 5f 5d
> [   36.138053] EIP: [<f88431da>] kvm_handle_fault_on_reboot+0xe/0x12 [kvm] SS:ESP 0068:f6723f60
> [   36.139168] ---[ end trace 6acc003c8ce73117 ]---
>
>
> It seems that it doesn't affect the kvm performance/functioning. Here's the processor information:
>    

Can you try the full 2.6.32.y kernel (without kmod-kvm)?  If it works, 
it's likely a kmod-kvm problem.  If it doesn't, it's probably a cpu 
setup problem.

Please post an objdump of vmx.o function vmx_init (might be renamed to 
init_module).

-- 
error compiling committee.c: too many arguments to function

