Return-Path: <linux-kernel-owner+w=401wt.eu-S935313AbXLQCRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935313AbXLQCRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXLQCRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:17:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:26978 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbXLQCRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:17:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=sZhjmZmFC40HdOHPjm9anVzDOlUlzSpSSpCUtt6SO6CiVN8fMhZdGdCaZQ56P6120eql9XG3kZjqrxlJ0gRcM8CtyhSGrr7vcJk2gHZ3ZVeZZlA3+bdyiHGFLLklzM0xWvPclPXVv0uTvbIZgFIc9BmnGFgSdX+QVLXXe8iYw7o=
Message-ID: <4765DBB6.8080305@gmail.com>
Date: Mon, 17 Dec 2007 03:15:18 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "David P. Reed" <dpreed@reed.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <469578CD.3080609@reed.com>	<1184216528.12353.203.camel@chaos>	<1184218962.12353.209.camel@chaos>	<46964352.7040301@reed.com>	<1184253339.12353.223.camel@chaos>	<469697C6.50903@reed.com>	<1184274754.12353.254.camel@chaos>	<4761F193.7090400@reed.com>	<20071214131502.GA14359@elte.hu>	<4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu> <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <4765B0CF.2040000@reed.com> <4765D745.7040306@gmail.com> <4765D922.3050703@zytor.com>
In-Reply-To: <4765D922.3050703@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-12-07 03:04, H. Peter Anvin wrote:

> Rene Herman wrote:
>> On 17-12-07 00:12, David P. Reed wrote:
>>
>>> Rene Herman wrote:
>>>> David: I've plugged in your DMI values in this. Could you perhaps 
>>>> test this to confirm that it works for you?
>>>>
>>> Will test it by tomorrow morning.
>>
>> Might as well test the new version then. Ingo Molnar requested a few 
>> changes and this fixes a couple of problems as well.
>>
> 
> As far as I can tell, the code still uses udelay() before calibration if 
> io_delay=udelay?
> 
> Just so we're clear on that...

Yes. This patch is explicitly about the alternate port and not about udelay. 
  As discussed (and changelogged) the calibration is just one problem with 
PCI posting and possible SMP races the other ones. Ingo Molnar wanted it as 
a debugging thing already though.

Once we start discussing udelay() again I believe we should go with the 
simple per CPU-Family loops_per_jiffy initialization to fix that first 
problem (and I guess I could hack that in now) but then the bigger problem 
remains and will need a fair amount of testing at least and mostly on 
machines that are by now gathering dust in a few basements...

Rene


