Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZLYCbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZLYCbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 21:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZLYCbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 21:31:22 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:4651 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZLYCbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 21:31:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Te74rfBu9OWXIRWAmczw3N1UsMiuautE+TcS1bvJWNRHSgNHJgxR0MRUFWHGY3liGc
         nHJcfCsYFhjTnXnPA3NAPn11JyJ4Kq8y0fx4ZQGra3pkR3cT2AHXmdyBKJo8ygukJ1La
         adYZfqAPfnUf6OAknHg1jmDVNff0QjNwKtHTs=
MIME-Version: 1.0
In-Reply-To: <5d75f4610912240722i7b282289id013b85f3d4927cd@mail.gmail.com>
References: <5d75f4610912240203x61a45505s213f29809824a854@mail.gmail.com>
	 <4B333EAD.1000202@gmail.com>
	 <5d75f4610912240722i7b282289id013b85f3d4927cd@mail.gmail.com>
Date: Fri, 25 Dec 2009 10:31:18 +0800
Message-ID: <2375c9f90912241831u57bb6fbfjd878876635cfea1a@mail.gmail.com>
Subject: Re: strange stuff in dmesg
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: BuraphaLinux Server <buraphalinuxserver@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 11:22 PM, BuraphaLinux Server
<buraphalinuxserver@gmail.com> wrote:
> On 12/24/09, Justin P. Mattock <justinmattock@gmail.com> wrote:
>> On 12/24/09 02:03, BuraphaLinux Server wrote:
>>> On my Dell OptiPlex 330 machines with kernel 2.6.32.2 I get a strange
>>> WARNING.  Do I need to worry?  Here is the warning:
>>>
>>> [    0.000000] ------------[ cut here ]------------
>>> [    0.000000] WARNING: at mm/page_alloc.c:1805
>>> __alloc_pages_nodemask+0x1b6/0x730()
>>> [    0.000000] Hardware name: OptiPlex 330
>>> [    0.000000] Modules linked in:
>>> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32.2 #1
>>> [    0.000000] Call Trace:
>>> [    0.000000]  [<ffffffff8108e806>] ? __alloc_pages_nodemask+0x1b6/0x730
>>> [    0.000000]  [<ffffffff81043f68>] warn_slowpath_common+0x78/0xd0
>>> [    0.000000]  [<ffffffff81043fcf>] warn_slowpath_null+0xf/0x20
>>> [    0.000000]  [<ffffffff8108e806>] __alloc_pages_nodemask+0x1b6/0x730
>>> [    0.000000]  [<ffffffff810b4e28>] alloc_pages_current+0x78/0xf0
>>> [    0.000000]  [<ffffffff8108da69>] __get_free_pages+0x9/0x50
>>> [    0.000000]  [<ffffffff810bb912>] __kmalloc+0x112/0x120
>>> [    0.000000]  [<ffffffff8146e773>] vgacon_scrollback_startup+0x13/0x70
>>> [    0.000000]  [<ffffffff811d29b3>] vgacon_startup+0x2a3/0x420
>>> [    0.000000]  [<ffffffff816fc556>] con_init+0x1b/0x230
>>> [    0.000000]  [<ffffffff816fba00>] console_init+0x22/0x42
>>> [    0.000000]  [<ffffffff816d4b8f>] start_kernel+0x240/0x3be
>>> [    0.000000]  [<ffffffff816d4289>] x86_64_start_reservations+0x99/0xb9
>>> [    0.000000]  [<ffffffff816d4389>] x86_64_start_kernel+0xe0/0xf2
>>> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
>>>
>>> I also got it on 2.6.31.9, but had waited to ask hoping 2.6.32.2 would fix
>>> it.
>>>
>>> Attached is my config
>>>
>> was there a kernel that did not do this?
>> if so can you try a bisect on this?
>>
>> Justin P. Mattock
>>
>
> It took a while, but I have verified that 2.6.30.10 works without any
> message, and 2.6.31 has the error message (but otherwise seems to run
> ok).  The hex codes are different, but the function names match and
> are in the same places.
>
> Does it have to be git bisect, or will trying the 2.6.31rc[1-9] be
> enough instead?  The Documentation/BUG-HUNTING does not give detailed
> enough instructions for me to do the bisect thing.

Hey, the problem is that you configured VGACON_SOFT_SCROLLBACK_SIZE
to be CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=65536, which will be
65536Kb, i.e. 16384 pages, how huge! :)

We shoud limit the number of VGACON_SOFT_SCROLLBACK_SIZE. I will cook
a patch now...
