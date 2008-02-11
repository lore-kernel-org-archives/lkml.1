Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYBKFwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYBKFwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 00:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYBKFwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 00:52:23 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:48172 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYBKFwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 00:52:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oo3qV8lTAmYVdSvJoMwb15xrAhlIV/1e3XeiUvhru2fjtxEIyMqkotPxiq2jGQj9ink17v2/EjnwRuVcVVWrY3Gd5D6LSH9bFi0Hip1fEn+m1g0cZHPLGxJIg7PwFuScZWWp2c3udHcirnpx36g/ZDQ0zJhDKeNaUN0mt6B5GPk=
Subject: Re: [2.6.25-rc1 regression] Suspend to RAM (bisected)
From: Calvin Walton <calvin.walton@gmail.com>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
In-Reply-To: <47AFDC4D.4070400@gmail.com>
References: <47AFDC4D.4070400@gmail.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 00:47:44 -0500
Message-Id: <1202708864.5206.0.camel@zem>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 03:25 -0200, Carlos R. Mafra wrote: 
> Hi,
> 
> I want to report that suspend to RAM stopped working on my Sony Vaio 
> VGN-FZ240E in 2.6.25-rc1 and that I could bisect the problem down
> to:
> 
> commit bc71bec91f9875ef825d12104acf3bf4ca215fa4
> Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
> Date:   Thu Jan 31 17:35:04 2008 -0800
> 
>     ACPI: enable MWAIT for C1 idle

I normally hate to throw in a 'me-too', but I'm also seeing a
suspend-to-ram regression on my Thinkpad R61i that I've managed to
bisect down to the same patch series.

You beat me emailing the issue to the list by a few minutes :)

> The problem with suspend to RAM is that right after typing (from inside X)
> 'echo mem > /sys/power/state' the screen becomes black and the laptop 
> freezes. I have to use SysRq+b to reboot.

My symptoms in this case are slightly different - the suspend appears to
work correctly, and is fast. However, when I resume, the screen lights
up quickly, but the system hangs for nearly a minute with the suspend
light still on solid before it actually resumes. No delay is visible in
dmesg; this apparently happens before the "return to C".

> I tried to revert the above commit (bc71bec) on top of 2.6.25-rc1, but
> the compilation fails. It turns out that I have to revert also 9a0b8415 and
> 9b12e18c to be able to compile without errors. 
> 
> After reverting the 3 commits mentioned above, the resulting 2.6.25-rc1 kernel
> can suspend to RAM again (and I must say that it is better that 2.6.24, because
> now it resumes directly into X and I don't need to use Crtl-Alt-F1 and Alt-F7 to
> go back to X as I used to do before).

I just tried reverting the above-mentioned 3 commits, doing so fixes the
delay. 

> The laptop is a Core 2 Duo T7250 2.0 GHz, running Mandriva 2008.0 in 64-bit mode, with the
> following graphics card:
> VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c) (prog-if 00 [VGA])

Rather similar system - I have a core 2 duo 1.5 running x86_64 gentoo,
and a GM965 chip (using uvesafb)

> 
> If there is anything else I can do to help please let me know.
> 
> Carlos R. Mafra

-- 
Calvin Walton <calvin.walton@gmail.com>


