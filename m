Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYK1KD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYK1KD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYK1KDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:03:08 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:14493 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYK1KDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:03:06 -0500
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <492FC1D0.2040408@tremplin-utc.net>
Date: Fri, 28 Nov 2008 11:02:56 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.18) Gecko/20081120 Mandriva/2.0.0.18-1mdv2009.1 (2009.1) Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, trenn@suse.de, hmh@hmh.eng.br
Subject: Re: HP accelerometer: free fall detection working, testers wanted
References: <20081121212121.GA7222@elf.ucw.cz> <20081128082215.GA2013@elf.ucw.cz>
In-Reply-To: <20081128082215.GA2013@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schreef:
> Hi!
> 
> I got free fall detection to work -- apparently BIOS does all the
> important stuff itself. 
> 
> Now... I'd like some testers. (Don't comment on code... yet. Yes, it
> has some issues).
>
Hi Pavel,
I'll try to test this weekend.

Out of curiosity, what did you change compared to the original version
of the driver? Did you just disable the set up code?

Also, how do you try free fall? Did you try also with the lid opened?
> hp3dg script should do all the important things.
:
> --- /dev/null
> +++ b/Documentation/hwmon/hp3dg
:
> +while true; do
> +	./readaccel foo
> +	unload 2
> +	if cat /proc/acpi/button/lid/LID/state | grep open && cat /proc/acpi/ac_adapter/AC0/state | grep off-line; then
> +		unload 20
> +	fi
> +done
Why a special case if the lid is opened and the laptop unplugged? Is it
a special behaviour of the hardware, or simply some kind of basic user
behaviour guess?

See you,
Eric
