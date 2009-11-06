Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbZKFUf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbZKFUf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 15:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759725AbZKFUfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 15:35:55 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:32915 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759704AbZKFUfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 15:35:55 -0500
Message-ID: <4AF488A7.4010408@free.fr>
Date: Fri, 06 Nov 2009 21:35:51 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.22) Gecko/20090605 Iceape/1.1.17 (Debian-1.1.17-2)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Using x86 segments against NULL pointer deference exploit
References: <1257512389.4af41dc504e1b@imp.free.fr> <20091106131330.0ce956f4@lxorguk.ukuu.org.uk>
In-Reply-To: <20091106131330.0ce956f4@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox wrote:
> On Fri, 06 Nov 2009 13:59:49 +0100
> castet.matthieu@free.fr wrote:
> 
>> Hi,
>>
>> I am wondering why we can't set the KERNEL_DS data segment to not contain the
>> first page, ie changing it from R/W flat model to R/W expand down from
>> 0xffffffff to 4096.
> 
> For one it is enormously expensive because the moment you have segment
> limits all sorts of stuff goes slower.
We can always imagine a lazy mechanism that will enable segment limit when page0 is mapped.
That will only slow down the machine when wine & co are running. 

> and for APM and so on.
APM clears all segment before calling bios (APM_ZERO_SEGS is defined for detecting buggy bios) 
and pnpbios seems to have their own segment (GDT_ENTRY_PNPBIOS) There is also GDT_ENTRY_APMBIOS_BASE,
but that seems unused.

> You also do sometimes need low 4K
> access for wine/dosemu etc as you guess - 
That's a bigger problem. If there not many access we can imagine fix it with trap/single step.

> 64bit you don't have a lot of those features ayway.
Yes.

May be the sane way should be to forbid mapping page 0, and make run application needing page 0 in a
emulator. After all it is for special case [1] :
- Win16 binary for wine
- upstream version of dosemu and qemu have workaround

But some distro still set mmap_min_addr to 0 (ubuntu+wine, ...) :(

Matthieu

[1] http://wiki.debian.org/mmap_min_addr
