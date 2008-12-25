Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbYLYRP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbYLYRP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 12:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYLYRPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 12:15:16 -0500
Received: from smtp.witbe.net ([81.88.96.48]:60047 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbYLYRPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 12:15:14 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Dec 2008 12:15:13 EST
Date: Thu, 25 Dec 2008 23:09:34 +0100
From: Paul Rolland <rol@as2917.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: rol@as2917.net
Subject: 2.6.27.9 - Resuming from hibernate locks after "CPU1 is down"
Message-ID: <20081225230934.380c953f@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.6.0-rc2 (GTK+ 2.12.8; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to have suspend to disk and suspend to RAM work on my machine
(Dell Inspiron 6400, 2Go RAM, with an Intel Mobile 945GM/GMS, 943/940GM
L Express Integrated Graphics Controller.

To suspend, I'm using the "echo mem | disk > /sys/power/state" command.

As of now, using suspend to RAM allow the machine to suspend, and resume is
nearly OK except the video is not restored, and the screen stays black (but
keyboard is Ok, I can launch any command I want, so I can restart).

When suspending to disk, suspend is Ok with :
echo -n 2097152000 > /sys/power/image_size ;
echo -n disk > /sys/power/state
and resuming detects the image in the swap partition. So, I have on the
console, when I add "no_console_suspend" on the boot command line :
PM: loading image data pages...
PM: read xxxxx kbytes in y.zz seconds
...
[stuff about scsi/sda]
Disabling non-boot CPUs
CPU1 is now offlone
SMP alternatives: switching to UP code
CPU1 is down

and then, nothing :( machine is dead frozen. CAPS Lock doesn't toggle the
keyboard LED anymore, I need to manually power off and power on the machine.

I must add that these are my first attempts. So, this is not to be
considered a regression.

Is there anything else I can do to try to debug the resume ?

Regards,
Paul

-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un
navigateur "Some people dream of success... while others wake up and work
hard at it" 

"I worry about my child and the Internet all the time, even though she's
too young to have logged on yet. Here's what I worry about. I worry that 10
or 15 years from now, she will come to me and say 'Daddy, where were you
when they took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
