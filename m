Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZGBF0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZGBF0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZGBF0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:26:03 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:15918 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZGBF0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:26:01 -0400
X-Greylist: delayed 686 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 01:26:01 EDT
X-RZG-AUTH: :OUwRflWtc/HJSDZEw3LQ3i60a5MmrHxmAfkINEnIhH6pzDtH7Q6hUahb
X-RZG-CLASS-ID: mo05
Message-ID: <4A4C4226.8000302@acm.org>
Date: Thu, 02 Jul 2009 07:14:14 +0200
From: U Kuehn <ukuehn@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jeremy@jeremyms.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by
 encrypting page cache
References: <87hbxx0wcp.fsf@jeremyms.com> <200907011755.10386.rjw@sisk.pl>	<874otw15r6.fsf@jeremyms.com> <200907020041.52198.rjw@sisk.pl> <87r5x0ypev.fsf@jeremyms.com>
In-Reply-To: <87r5x0ypev.fsf@jeremyms.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
>> What is the particular attach scenario you'd like to prevent
> 
> The standard cold boot attack, which basically allows the attacker to
> obtain a copy of the data in RAM.  System is powered on.  RAM is
> optionally cooled.  RAM is then quickly removed from the original
> machine, placed in another machine, and copied.  See
> http://en.wikipedia.org/wiki/Cold_boot_attack
> 
> The wikipedia page links to this Youtube video that nicely demonstrates
> the attack:
> 
> http://www.youtube.com/watch?v=JDaicPIgn9U
> 
> The cooling helps to preserve the data for longer, but is not always
> even necessary.  Special hardware is not even needed.  Depending on
> whether the BIOS clears the memory during the POST, it might also be
> possible to do the attack on the same machine (i.e. without having to
> move the RAM into another machine) by rebooting it and booting from
> e.g. a CD-ROM or USB drive.
> 

This attack scenario essentially attacks the standard assumption that
memory contents is _immediately_ lost once power to the RAM is removed.

Essentially, the same problems arise whether the machine is suspended to
RAM or is just left on, with some screen saver or something similar in
place. So if the machine is snatched out of your hands it is still
running...

That's the reason why I personally prefer suspend-to-disk over
suspend-to-ram. Of course, if you have encryption in place, e.g. for you
home partition, it is necessary that the swap space is encrypted so that
the system state is protected during suspend-to-disk.

The approach to encrypt the memory contents during suspend-to-ram seems
to be a very fundamental change in the kernel, in order to protect
against a very specific attack. And unfortunately it helps only against
an cold-boot attack that happens during suspend-to-ram. It does not
protect against the attack taking place when the machine is just "on".

Just my 2c.

With best regards,
Ulrich

