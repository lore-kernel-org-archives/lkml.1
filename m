Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZGIDC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZGIDC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZGIDCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:02:21 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:39084 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbZGIDCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:02:21 -0400
Message-ID: <4A555DA7.6020009@oracle.com>
Date: Wed, 08 Jul 2009 20:01:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Dave Airlie <airlied@gmail.com>,
       Greg KH <gregkh@suse.de>, Peter Jones <pjones@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
References: <20090623144221.GA29593@suse.de> <4A54A538.3080407@redhat.com>	 <20090708140419.GA20418@suse.de> <4A54A938.5030807@redhat.com>	 <20090708145625.GA20690@suse.de> <4A54B5C2.9000908@redhat.com>	 <20090708154758.GB20979@suse.de>	 <21d7e9970907081423v6d3830eey227f3d54b10382a6@mail.gmail.com>	 <b6a2187b0907081743w61102ff4u75d15c2f3cae26d@mail.gmail.com>	 <4A554F1E.5020508@oracle.com> <b6a2187b0907081931w7dcf2544m4b580f7841b80cf3@mail.gmail.com>
In-Reply-To: <b6a2187b0907081931w7dcf2544m4b580f7841b80cf3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A555D9B.0122:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Thu, Jul 9, 2009 at 9:59 AM, Randy Dunlap<randy.dunlap@oracle.com> wrote:
>>> Without CONFIG_EMBEDDED ...
>>>   CONFIG_NAMESPACES=y
>> Under General Setup, Namespaces support
> 
> You're good. Thanks.
> 
>>> With CONFIG_EMBEDDED=y ...
>>>   # CONFIG_NAMESPACES is not set
>>>   CONFIG_VMSPLIT_3G=y
>> Under Processor type and features, Memory split
> 
> This is one I'm having trouble with. When CONFIG_EMBEDED is not set, I
> can't find any "VMSPLIT" in .config, but when CONFIG_EMBEDDED is set,
> I'll have to choose the VMSPLIT option. Should I select VMSPLIT_3G?

Probably so, since that's the default.

> Here's what it says ...
> 
>   | Prompt: Memory split
>   |   Defined at arch/x86/Kconfig:1062
>   |   Depends on: EXPERIMENTAL && X86_32 && EMBEDDED
>   |   Location:
>   |     -> Processor type and features
>   |   Selected by: EXPERIMENTAL && X86_32 && EMBEDDED && m

arch/x86/Kconfig says:

choice
	depends on EXPERIMENTAL
	prompt "Memory split" if EMBEDDED
	default VMSPLIT_3G
	depends on X86_32
	---help---
	  Select the desired split between kernel and user memory.

	  If the address range available to the kernel is less than the
	  physical memory installed, the remaining memory will be available
	  as "high memory". Accessing high memory is a little more costly
	  than low memory, as it needs to be mapped into the kernel first.
	  Note that increasing the kernel address space limits the range
	  available to user programs, making the address space there
	  tighter.  Selecting anything other than the default 3G/1G split
	  will also likely make your kernel incompatible with binary-only
	  kernel modules.

	  If you are not absolutely sure what you are doing, leave this
	  option alone!

~Randy
