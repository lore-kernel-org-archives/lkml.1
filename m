Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbXLQNib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbXLQNib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762497AbXLQNiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:38:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:31462 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762934AbXLQNiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:38:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=RSGm0HRZWbJkK701jFjuYSFwBONh2HGmoFCcuPp8BQih+DYvb7qaKiPShTqG0v6NQQau2zddIOCi8+oXENcRFuJsuVu9gDdB7ytfFE+uZlqvY4ko7jzMWLhcwVR07CUB9BOWddKkeC2v6+QJL0cNafZ1bS+eWeZlCj1WRdF9vQA=
Message-ID: <47667B62.5080508@gmail.com>
Date: Mon, 17 Dec 2007 14:36:34 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com>
In-Reply-To: <47667A85.3080100@reed.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-12-07 14:32, David P. Reed wrote:

> Rene Herman wrote:
>> No, most definitely not. Having the user select udelay or none through 
>> the kernel config and then the kernel deciding "ah, you know what, 
>> I'll know better and use port access anyway" is _utterly_ broken 
>> behaviour. Software needs to listen to its master.
>>
> When acting as an ordinary user, the .config is beyond my control 
> (except on Gentoo).   It is in control of the distro (Fedora, Ubuntu, 
> ... but perhaps not Gentoo).  I think the distro guys want a default 
> behavior that is set in .config, with quirk overrides being done when 
> needed.   And of course the user in his/her boot params gets the final say.

Yes, and when the user/distributor specifically selected udelay or none as 
an I/O delay method it makes no sense whatsoever to have the kernel override 
that again -- the DMI hack only fixes something for the default case, when 
_no_ specific choice had been made (which the current setup can't express 
but mine did).

I feel particularly strongly (always) about that "listen to its master" bit. 
The kernel does not know better then whomever configured it, even when it does.

Rene.


