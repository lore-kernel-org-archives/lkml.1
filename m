Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbZJKQta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbZJKQta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 12:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbZJKQt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 12:49:29 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:51419 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756184AbZJKQt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 12:49:28 -0400
X-Greylist: delayed 1538 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Oct 2009 12:49:28 EDT
Date: Sun, 11 Oct 2009 18:21:55 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-input@vger.kernel.org
Subject: [bisected regression] Touchpad "paste" stops working after suspend
	to RAM
Message-ID: <20091011162155.GA4260@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the latest 2.6.32-rc3+ kernel, the "paste" operation via the 
touchpad of my Vaio laptop does not work after suspend to RAM.

It works flawlessly before s2ram; I select the text with the touchpad
and tap quickly its right corner to paste the selected text.
After a plain 'echo mem > /sys/power/state' the "paste" does not work.

I bisected it to commit ffd0db97196c1057f09c2ab42dd5b30e94e511d9 ("Input: 
add generic suspend and resume for input devices").

I haven't tested if reverting it from mainline fixes the issue, but 
from the patch description I guess that bisection landed correctly
on the culprit.

I have a recent dmesg from my laptop here: 

http://www.aei.mpg.de/~crmafra/dmesg-2.6.32-rc3-wifi.txt

(the wifi warnings there are related to another issue, and the touchpad
problem happens independently of those warnings).

I can test patches and provide more info if necessary.


PS: Due to some HAL configuration issue I have this line in my .bashrc

synclient RTCornerButton=2

which makes the right corner region capable of pasting. When the
kernel is "good", it comes back from resume and I don't need to
run this command again for the 'paste' operation to work. When
the kernel is "bad" running this command has no effect and 
"paste" does not work in any way.





