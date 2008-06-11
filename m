Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYFKEd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYFKEd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYFKEdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:33:17 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:35882 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750991AbYFKEdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:33:17 -0400
Message-ID: <484F5582.5000805@gawab.com>
Date: Tue, 10 Jun 2008 21:33:06 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080522)
MIME-Version: 1.0
To: Romano Giannetti <romanol@upcomillas.es>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       lkml <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?U2HDr3Zhbm4gQ2FyaWduYW4=?= <oxmosys@gmail.com>
Subject: Re: [regression?] Sometime (often) X come out blank (black screen)
 on cold boot - Intel chipset
References: <1213101501.21041.9.camel@pern>
In-Reply-To: <1213101501.21041.9.camel@pern>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Romano Giannetti wrote:
> I just opened this: http://bugzilla.kernel.org/show_bug.cgi?id=10892 . I
> think itś a regression, but (read the description) I am not so sure, so
> I checked regression but I have not blocked Rafael's metabug. 
>
> Latest working kernel version: 2.6.25
> Earliest failing kernel version: After 2.6.25, exatcly don't know, probably
> 2.6.26-rc3
> Distribution:Ubuntu 8.04 Hardy
> Hardware Environment: toshiba U305 intel-based laptop, see
> http://bugzilla.kernel.org/attachment.cgi?id=16067&action=view
> Software Environment:xserver-xorg-video-intel  2:2.2.1-1ubuntu12, see also
> http://bugzilla.kernel.org/attachment.cgi?id=16066&action=view
> Problem Description:
>
> Sometime, on cold boot (after the laptop has been shut off), when the screen
> switch from the Ubuntu startup to gdm, the screen goes blank. Forever.
> Rebooting (warm) with the same kernel cures it, sometime. If I reboot 2.6.25 it
> cures it everytime. 
>
> Otherwise, the system seems to be working.
>
> It was difficult to see because I almost never do a cold boot, the laptop is
> either sleeping (s2ram) or on, or (warm) rebooted when I test a new kernel. 
>
> Helps / tricks to gather more data when it happens are welcome.
>
>   
Seems like the same bug I reported:
https://bugs.freedesktop.org/show_bug.cgi?id=15602

Can you confirm, so Rafael Wysocki can mark your report 
http://bugzilla.kernel.org/show_bug.cgi?id=10892 as a dup of 
http://bugzilla.kernel.org/show_bug.cgi?id=10235.

Does disabling the boot splash fix the problem? You could also try 
disabling gdm and starting X manually. When I disable usplash it fixes 
the problem.

Are you sure kernel 2.6.25 doesn't also have the problem? Because I 
first saw the issue in 2.6.25-rc1. I tried doing a git bisect and came 
up with 8f4d37ec073c17e2d4aa8851df5837d798606d6f as the first bad.
> sched: high-res preemption tick
> Use HR-timers (when available) to deliver an accurate preemption tick.
You could try git bisecting the bug, but you might run into problems. 
When I got down to the last ~80 commits the compiled kernel corrupted my 
real time clock! So, I'm not 100% sure the the commit that git reported 
was the _exact_ first bad, but fairly close (that, and the blank screen 
doesn't happen all the time). But if your git bisect returns the same or 
similar commit we might be able to narrow down the possibilities.

Jesse,
    It seems the problem might be related to usplash. In each reported 
case Ubuntu and usplash were used, and disabling usplash (at least for 
me) seems to fix the problem. Could there be some timing feature that 
usplash uses that isn't guaranteed/changed with some optimizations of 
CFS (or HR-timers) that went into 2.6.25? I've cc'ed Saïvann Carignan, 
who seems to be the most active contributer to usplash.

Justin Madru

