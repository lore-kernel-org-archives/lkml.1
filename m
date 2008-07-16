Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbYGPWCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbYGPWCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbYGPWCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:02:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:41154 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbYGPWCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:02:33 -0400
Cc: linuxppc-dev@ozlabs.org, davej@redhat.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <702673D5-9D36-4428-91FB-3D0697A1D5ED@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
In-Reply-To: <20080716214722.GA6251@ld0162-tx32.am.freescale.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET
Date: Wed, 16 Jul 2008 17:01:28 -0500
References: <Pine.LNX.4.64.0807160838520.14127@blarg.am.freescale.net> <20080716214722.GA6251@ld0162-tx32.am.freescale.net>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 16, 2008, at 4:47 PM, Scott Wood wrote:

> On Wed, Jul 16, 2008 at 08:39:12AM -0500, Kumar Gala wrote:
>> If we don't enable FS_ENET we get build issues:
>>
>> arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
>> arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to  
>> `alloc_mdio_bitbang'
>> arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to  
>> `mdiobus_register'
>
> How is this possible?  CONFIG_EP8248E selects CONFIG_MDIO_BITBANG.
>
>> +#ifdef CONFIG_FS_ENET_MDIO_FCC
>> static void ep8248e_set_mdc(struct mdiobb_ctrl *ctrl, int level)
>> {
>> 	if (level)
>> @@ -164,6 +165,7 @@ static struct of_platform_driver  
>> ep8248e_mdio_driver = {
>> 	.probe = ep8248e_mdio_probe,
>> 	.remove = ep8248e_mdio_remove,
>> };
>> +#endif
>
> This is wrong -- ep8248e doesn't use the FS_ENET_MDIO_FCC code.

You're correct this should be CONFIG_MDIO_BITBANG

- k
