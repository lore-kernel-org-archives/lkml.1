Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbZGaPRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbZGaPRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 11:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZGaPRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 11:17:23 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:8225 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZGaPRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 11:17:23 -0400
Date: Fri, 31 Jul 2009 17:17:25 +0200
To: linux-kernel@vger.kernel.org
Subject: Intel 3945ABG - problems on 2.6.30.X
From: dienet <dienet@poczta.fm>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-2
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.uxxt3bv7wcw97g@t61.dienet.ath.cx>
User-Agent: Opera Mail/9.64 (Linux)
X-EMID: 7a05bae4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I got 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG  
[Golan] Network Connection (rev 02) in my T61.

I use this acpi script to switch it on and off:

#!/bin/bash

state=`cat /sys/bus/pci/drivers/iwl3945/0000:03:00.0/enable`

if [ "$state" == "1" ]; then

         logger "Wifi off"

         if [ -x /etc/rc.d/rc.inet1 ]; then
                 . /etc/rc.d/rc.inet1 stop
         fi

         echo disable > /proc/acpi/ibm/bluetooth

         /usr/bin/osd.sh "Wifi: [Off]"
else
         logger "Wifi on"

         if [ -x /etc/rc.d/rc.inet1 ]; then
                 . /etc/rc.d/rc.inet1 start
         fi

         if [ -x /etc/rc.d/rc.inet1 ]; then
                 . /etc/rc.d/rc.inet1 eth0_stop
         fi

         echo disable > /proc/acpi/ibm/bluetooth

         /usr/bin/osd.sh "Wifi: [On]"
fi


and it works quite nice on 2.6.29. Value in  
/sys/bus/pci/drivers/iwl3945/0000:03:00.0/enable is changing.
I just want to try this out on some 2.6.30.X. But on 2.6.30.X it don't  
works :/ How should I do it on 2.6.30.X?

I tried to do some echo 0 > enable but with no sucess.

There's one more thing. On 2.6.30.X LED from wifi indicator is not  
blinking when there is wifi traffic.
On 2.6.29 this LED blinks until you do not do supsend-to-ram. After STR it  
do not blinks.

If I need to post some parts of .config (from 2.6.30.X) or any other data,  
just tell me, but I thinkg I configured it out good.

-- 
pozdr0
dienet

"Old C programmers never die. They're just cast into void."

----------------------------------------------------------------------
Wygraj zestaw kosmetykow!
Sprawdz >> http://link.interia.pl/f22ac

