Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbXFXUqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbXFXUqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXFXUqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:46:36 -0400
Received: from ipx20189.ipxserver.de ([80.190.249.56]:1653 "EHLO
	ipx20189.ipxserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbXFXUqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:46:35 -0400
Date: Sun, 24 Jun 2007 22:46:29 +0200
From: Christian Leber <christian@leber.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070624204629.GA28049@core>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz> <20070616194634.GA15953@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070616194634.GA15953@core>
X-Accept-Language: de en
X-Location: Europe, Germany, Mannheim
X-Operating-System: Debian GNU/Linux (sid)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 09:46:34PM +0200, Christian Leber wrote:

> The results are a bit unclear, I took a 2.6.22-rc4 with beep.
> Logged into KDE.
> (hardware: Dell Latitude D810)
> 
> S = successfull resume
> D = had to resume 2 times, that means when pressing the power button the
> LED goes from blinking to on and after a few seconds it goes back to
> blinking, but without a beep in between; after pressing the power button
> a second time resume is successfull
> F = resume failes, NO beep
> 
> -run 1: D D F
> -run 2: D D D(some X garbadge) F
> -run 3: S S S S S S F
> -run 4: S S F
> -run 5: D F

I tracked the problem halfway down, with 2.6.20-rc1-ubuntu1 [1] it works
and with 2.6.20-rc2-ubuntu2 [2] not.

The diff is here, unfortunately the acpi changes are about 100kb.
http://debian.christian-leber.de/2.2-3.4.patch

(the problem is a bit different, it suspends, when trying to resume it
goes back to suspend and when i try again it's dead)

For some reason that i don't get vanilla 2.6.20-rc1 doesn't boot because
ata_piix doesn't work "PCI: Unable to reserve I/O region...." no remote
idea why it works with the ubuntu kernel.
So i can't bisect it.


Christian Leber


[1] https://launchpad.net/ubuntu/+source/linux-source-2.6.20/2.6.20-2.2
[2] https://launchpad.net/ubuntu/+source/linux-source-2.6.20/2.6.20-3.4

-- 
http://rettetdieti.vde-uni-mannheim.de/

