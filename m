Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbZLBGdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbZLBGdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZLBGdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:33:13 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:44991 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbZLBGdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CUX0kMKbmOxKuUuFj1eVJqzDUSlUBgw7wotF0M3AWyv/iZzX9zHe3FJM96pkLoNzVa
         5iQCpeVN7bwfn5HqXGpmHiuye44fmDzOcYYmG/zSTyC2M3Gvcd6ovbGIs23RvxxH3OjX
         DkB1i7sWSanUQ7YQkcG0Ky+gC/DhgHOEwXduA=
MIME-Version: 1.0
In-Reply-To: <E389CC83-307F-4A7D-B90B-CD928A1D1D1D@kernel.crashing.org>
References: <1259663450-28790-1-git-send-email-leoli@freescale.com>
	 <1259665127.2076.363.camel@pasglop>
	 <2a27d3730912010334q24bf0e06g84839aae131475ec@mail.gmail.com>
	 <E389CC83-307F-4A7D-B90B-CD928A1D1D1D@kernel.crashing.org>
Date: Wed, 2 Dec 2009 14:25:47 +0800
X-Google-Sender-Auth: c56de1bb33664719
Message-ID: <2a27d3730912012225h3deab5dao2211bc404d247192@mail.gmail.com>
Subject: Re: [PATCH] powerpc/mm: setting mmaped page cache property through 
	device tree
From: Li Yang <leoli@freescale.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 1, 2009 at 10:35 PM, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>> The scenario for the first case is that in a multicore system running
>> ASMP which means different OS runs on different cores.  They might
>> communicate through a shared memory region.  The region on every OS
>> need to be mapped with the same cache perperty to avoid cache paradox.
>
> This isn't true.  In ASMP, you cannot usually do coherency between
> the different CPUs at all.  Also, in most PowerPC implementations,

Coherency can't be achieved with proper configuration and management?  Why so?

> it is fine if one CPU maps a memory range as coherent while another
> maps it as non-coherent; sure, you have to be careful or you will

But we do want the shared region to be coherent.  So mappings should
have the same cacheability property.

> read stale data, but things won't wedge.
>
>> The scenario for the second case is to pre-allocate some memory to a
>> certain application or device (probably through mem=XXX kernel
>> parameter or limit through device tree).  The memory is not known to
>> kernel, but fully managed by the application/device.  We need being
>> able to map the region cachable for better performance.
>
> So make the memory known to the kernel, just tell the kernel not to
> use it.  If it's normal system RAM, just put it in the "memory" node
> and do a memreserve on it (or do something in your platform code); if
> it's some other memory, do a device driver for it, map it there.

Your solution is feasible.  But the memory allocation is a software
configuration.  IMHO, it should be better and easier addressed by
changing configurations(like mem parameter) rather than the kernel
platform code which should address hardware configuration.

- Leo
