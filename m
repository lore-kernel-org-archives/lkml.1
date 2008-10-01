Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYJAQmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYJAQmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 12:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYJAQmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 12:42:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:48178 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYJAQmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 12:42:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aWjv0FKTqYZ0CSPDq9z6mbk5JcDWgFWMWrKOZ5jktbdESNGLYxvJ2UVYwZFG4eF5v8
         DBdQH8O6DCHuRjCDYCpGc/BwJ473ejVUvtGN8UZS92Us8aNWgvqjkSznbzaQyvuTBT7p
         PPlkHuQUXIz5VNNTmxhNT12ii+s94Ylp4M6cU=
Message-ID: <19f34abd0810010942ifef42efv6c45831789aa1293@mail.gmail.com>
Date: Wed, 1 Oct 2008 18:42:04 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] x86: fix virt_addr_valid() with CONFIG_DEBUG_VIRTUAL=y
Cc: "Vegard Nossum" <vegardno@ifi.uio.no>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <48E35E83.9040101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001104717.GA7925@ben.ifi.uio.no> <48E359B4.7050708@gmail.com>
	 <19f34abd0810010415s405dcd98j187e5c9c20fc2d16@mail.gmail.com>
	 <48E35E83.9040101@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 1:26 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 10/01/2008 01:15 PM, Vegard Nossum wrote:
>> On Wed, Oct 1, 2008 at 1:06 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>> x86_64 is screwed in the same way, isn't it?
>>
>> Hm. I didn't see any #ifdef CONFIG_DEBUG_VIRTUAL in the x86_64 code,
>> so I assumed it wasn't. But it seems that you are right (because the
>> checks, or at least some kind of checks, are _always_ performed on
>> x86_64 regardless of the CONFIG_DEBUG_VIRTUAL setting). Why doesn't
>> the checking in x86_64 code depend on DEBUG_VIRTUAL?
>
> Yeah, it does: VIRTUAL_BUG_ON depends on it...
>
> x86_64 just distinguish pointer to kernel image addresses (which are mapped only
> up to kernel image size from phys_base physical address) and whole physical
> memory map at another virtual address.

You are right.

But it seems that the current virt_addr_valid() doesn't take this into
account. Should virt_addr_valid() be modified (on both x86_32 and
x86_64) to take into account the same checks as __phys_addr() does
when DEBUG_VIRTUAL=y? Or is it enough to use pfn_valid()?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
