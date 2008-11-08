Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbYKHD0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbYKHD0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYKHD03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:26:29 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:38836 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYKHD02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:26:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=XTMXrmzvbbWTcvj5wVYYldmzNvdN65gKWgmemVgOdCnCt7fOcFEnEkE50s11OC8RUU
         A/KMzD8/J5bH0JG29IF5rGdY9jO0QR4KEQZhDKDBHwwcWO/lPqd8GRN0pPBdX/1UM/lG
         PmWss0ZJ07ShFy+o8D13vKwOe1oJIslyKz7/o=
Message-ID: <491506DB.1070000@gmail.com>
Date: Sat, 08 Nov 2008 05:26:19 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net
CC: alsa-devel@alsa-project.org
Subject: Bugs on aspire one A150
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have just bought an Aspire one A150, XP version,
as it was the only available here, and installed ubuntu on it.

Bugs I discovered so far:


** 1 - embedded controler works in polling mode, due to this:

[    0.708571] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    1.224043] ACPI: EC: missing confirmations, switch off interrupt mode.


Maybe this is the reason for the fact that gnome power manager freezes when I unplug
the AC, and freezes often when I try to see battery status.


(Note: same is seen on my acer aspire 5720)


** 2 - wireless: not to mention the fact that ath5k wasn't installed by default in ubuntu...
wireless more or less works, but kernel log is full of backtraces.
Was able to connect to my WPA2 access point.
Sometimes wireless fails completely, especially after suspend to ram.
Advanced features like monitor/injection work, but when I changed the card's
mac address it stopped working.
I also noticed that if I then start airodump, then wireless works with new mac.



** 3 - internal mic doesn't work.
tried model=acer, model=auto.
Overall it seems that alsa misprograms O/B realteck
codec.
I talk about this later.
Have same issue on my acer 5720



** 4 - wireless led doesn't work.
ath5k devs, can you fix this?


** 5 - coretemp doesn't show cpu temperature,
I have seen somewhere that atom support same thermal diode as core2
and only patch to detect it is needed.
Please include such path in 2.6.28 if exists.


** 6 - both card readers are missing from lspci, is this normal?

** 7 - opengl is broken, I tried running neverball in fullscreen, but it shows wrong/corrupted
textures (compiz is running, and working well thought)
 
Now I installed 2.6.28-rc3 (actually latest -git)


Sadly nothing improved.
I only found few regressions:



* Wireless now drops connection from my WPA2 access point after few minutes.
I changed temporarily its wireless protection to WEP and open mode, and both work
fine, maybe this is related to periodic key exchange WPA does?

* System doesn't reboot/shutdown, just hangs.





Best regards,
	Maxim Levitsky.
