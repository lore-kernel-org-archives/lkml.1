Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZCDXsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZCDXsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZCDXsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:48:46 -0500
Received: from gw.goop.org ([64.81.55.164]:37366 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbZCDXsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:48:45 -0500
Message-ID: <49AF135A.4060604@goop.org>
Date: Wed, 04 Mar 2009 15:48:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: __virt_addr_valid vs virtual percpu areas
References: <49AF075D.9070607@goop.org> <49AF0C81.7060908@gmail.com>
In-Reply-To: <49AF0C81.7060908@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> It's not (in the meaning of virt_* functions), but while booting we 
> don't have variables used in VMALLOC_START and VMALLOC_END ready for 
> use on i386.
>
> Maybe we can introduce more clever method/state which would say: hey, 
> vmalloc framework is up and running. And use instead (system_state != 
> SYSTEM_BOOTING) hack.

Yeah, I pieced that together.  I'm just testing a patch with a specific 
__vmalloc_start_set flag to test.

>> This is biting me because I need to translate percpu addresses
>> to pfns, but I only bother doing the full pagetable walk if
>> virt_addr_valid() is false (otherwise I just use __pa()).
>
> Do you need to bother also with vmalloc space?

percpu data gets mapped into the vmalloc region now (when using 4k page 
mappings, at least).

>> Removing this test doesn't seem to harm anything at first glance. Is
>> this OK to do in general (and can we quietly set fire to system_state
>> while we're about it)?
>
> I wouldn't do that, since vmalloc addr is not virt addr, again in the 
> meaning of virt_* functions. And the function wouldn't do the right 
> thing, at least in the RUNNING state anymore.

OK.

    J
