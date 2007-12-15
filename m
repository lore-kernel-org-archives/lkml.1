Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbXLOIOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbXLOIOq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 03:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXLOIOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 03:14:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:28572 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbXLOIOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 03:14:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HLmOCD62hWpixCPi1GHhzcZVZxQ3Fzuc1bsp45n4kksN2nuWYHcGBnOB2fEBmQ93VdHuoI8+UDUbYuCEuKZpulyZfr3n4Fmb+rRFz7XqtiSwou2iBe7Bmh9cM+Fb8+hJsKuQY0kO3/zVsRukGj91/aLM6IXIV+8FN2IYr0R36ew=
Message-ID: <47638C8C.2090604@gmail.com>
Date: Sat, 15 Dec 2007 09:13:00 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Rene Herman <rene.herman@keyaccess.nl>, rol@witbe.net
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net>
In-Reply-To: <20071215080831.404cdb32@tux.DEF.witbe.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-12-07 09:08, Paul Rolland wrote:
> Hello,
> 
> On Fri, 14 Dec 2007 23:29:55 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>> On Fri, 14 Dec 2007 14:13:46 -0800
>> "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>>> Pavel Machek wrote:
>>>> On Fri 2007-12-14 10:02:57, H. Peter Anvin wrote:
>>> How long will that take to boot on a 386?
>> Well the dumb approach to fix that would seem to be to initialise it to
>>
>> 	cpu->family   3 -> 50MHz 4 -> 300Mhz 5-> etc...
> 
> Just an idea : from what I've read, the problem (port 80 hanging) only occurs
> on 'modern' machines... So why not :
>  - use port 80 for old CPUs (PII, PIII) where it has never really been
>    a problem,
>  - use the cpu->family to do a best match for CPU freq
> thus we could avoid increasing boot time too much...

Yes, just posted a Patch-For-Comments that switches on the availability of a 
TSC (tsc_init sets tsc_disable also for !cpu_has_tsc) which would mean that 
only really old stuff would be using the outb still. A TSC is really all we 
need to have a sensible udelay().

Rene.
