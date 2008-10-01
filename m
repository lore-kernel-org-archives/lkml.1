Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYJAL1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYJAL1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 07:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYJAL1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 07:27:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:2776 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYJAL1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 07:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Xoa1gtdUbpm6ihN/nICiG1k+CrS9KZo07TEn3tERuu4J7Bt7yg7lK2TezcZCInh7kE
         JM+sXDL+z2Zh9lgR1FcDM4Ag+BB+HvDTN28VtCiUMGQNmO+75hwUj57veZgtaPLp/NMy
         lZs+oy/RIasAK6euF8EbcsOO9ia1etA6aD5MM=
Message-ID: <48E35E83.9040101@gmail.com>
Date: Wed, 01 Oct 2008 13:26:59 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Vegard Nossum <vegardno@ifi.uio.no>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
References: <20081001104717.GA7925@ben.ifi.uio.no> <48E359B4.7050708@gmail.com> <19f34abd0810010415s405dcd98j187e5c9c20fc2d16@mail.gmail.com>
In-Reply-To: <19f34abd0810010415s405dcd98j187e5c9c20fc2d16@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2008 01:15 PM, Vegard Nossum wrote:
> On Wed, Oct 1, 2008 at 1:06 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> x86_64 is screwed in the same way, isn't it?
> 
> Hm. I didn't see any #ifdef CONFIG_DEBUG_VIRTUAL in the x86_64 code,
> so I assumed it wasn't. But it seems that you are right (because the
> checks, or at least some kind of checks, are _always_ performed on
> x86_64 regardless of the CONFIG_DEBUG_VIRTUAL setting). Why doesn't
> the checking in x86_64 code depend on DEBUG_VIRTUAL?

Yeah, it does: VIRTUAL_BUG_ON depends on it...

x86_64 just distinguish pointer to kernel image addresses (which are mapped only
up to kernel image size from phys_base physical address) and whole physical
memory map at another virtual address.
