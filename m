Return-Path: <linux-kernel-owner+w=401wt.eu-S1763804AbXIKMUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763804AbXIKMUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbXIKMT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:19:59 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:54965 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753722AbXIKMT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:19:59 -0400
Message-ID: <46E687ED.9000802@grupopie.com>
Date: Tue, 11 Sep 2007 13:19:57 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Paulo Marques <pmarques@grupopie.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] video: uvesafb: Add X86 dependency.
References: <20070911081752.GA19495@linux-sh.org> <46E67EFD.2040902@grupopie.com> <20070911115346.GA23493@linux-sh.org>
In-Reply-To: <20070911115346.GA23493@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Tue, Sep 11, 2007 at 12:41:49PM +0100, Paulo Marques wrote:
>>[...]
>> Why do you say that it's x86 specific? Am I missing something?
>>
> The emulator it uses only runs on x86 and x86_64. Thus, it's x86
> specific. The v86d and uvesafb pages seem to be in disagremeent, unless
> by 'non-x86' it's only implying x86_64.
> 
> Additionally, it needs the vga I/O routines, as per vgacon. Most
> platforms don't define these.

I just saw the v86d emulator code, and you're right. It mmaps /dev/mem 
and assumes the video BIOS is mapped there.

We should try to change that to mmap something like 
"/sys/bus/pci/devices/0000:01:00.0/rom" instead so that it can work on 
any system with a video card plugged on a PCI bus.

It should also be possible for the emulator to translate in/out 
instructions to appropriate memory mapped I/O equivalents, no?

Anyway, I think it is up to Michal to decide if we should remove the 
kernel support for other archs, or let it stay a bit more while working 
on solving the v86d side of things. So I'll just step aside now....

-- 
Paulo Marques - www.grupopie.com

"667: The neighbor of the beast."
