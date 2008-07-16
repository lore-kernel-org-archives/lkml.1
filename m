Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYGPW4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYGPW4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYGPW4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:56:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:54176 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbYGPW4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:56:13 -0400
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Message-Id: <BB883309-0856-4371-BFC3-68E2F54B5B29@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Dave Jones <davej@redhat.com>
In-Reply-To: <20080716221949.GA18148@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET
Date: Wed, 16 Jul 2008 17:55:17 -0500
References: <Pine.LNX.4.64.0807160838520.14127@blarg.am.freescale.net> <20080716214722.GA6251@ld0162-tx32.am.freescale.net> <20080716215745.GA17093@redhat.com> <37829F82-D71C-4B42-A752-DA86C6F2764D@kernel.crashing.org> <20080716221949.GA18148@redhat.com>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 16, 2008, at 5:19 PM, Dave Jones wrote:

> On Wed, Jul 16, 2008 at 05:10:29PM -0500, Kumar Gala wrote:
>>
>> On Jul 16, 2008, at 4:57 PM, Dave Jones wrote:
>>
>>> On Wed, Jul 16, 2008 at 04:47:23PM -0500, Scott Wood wrote:
>>>> On Wed, Jul 16, 2008 at 08:39:12AM -0500, Kumar Gala wrote:
>>>>> If we don't enable FS_ENET we get build issues:
>>>>>
>>>>> arch/powerpc/platforms/built-in.o: In function  
>>>>> `ep8248e_mdio_probe':
>>>>> arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to
>>>>> `alloc_mdio_bitbang'
>>>>> arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to
>>>>> `mdiobus_register'
>>>>
>>>> How is this possible?  CONFIG_EP8248E selects CONFIG_MDIO_BITBANG.
>>>
>>> If CONFIG_PHYLIB=m however, that doesn't make any difference,  
>>> because
>>> vmlinuz is trying to use a symbol which now lives in a module.
>>
>> The mdiobus_register make sense, I'm not sure get why
>> alloc_mdio_bitbang is undefined.
>
> Erm, same reason.  it's built into phy.o, which ends up in the module,
> not the vmlinuz.
>
> (also, it doesn't look like it's exported even if it was built-in?)

It looks like the simplest solution at this point is to  
unconditionally select the PHYLIB for this board.  We should look at  
moving the low level mdio bitbang ops out so they can be built as a  
module.

- k
