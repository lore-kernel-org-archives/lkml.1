Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbYJaOsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbYJaOsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYJaOsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:48:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:58965 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYJaOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:48:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OlwBbRkaoyrKxsbfKdRQTD6UUtc6vHyWH6xRoxBxwofKrb4aAStgUi21bdDx5csYLn
         RJOqC0lYF8QI7PkJBIHtbtTIUs+XFPnGrTVeAQtB9gxvA1xNS6ObKVCiue68/5PEdlxN
         sT08fXb1wmyodwLYtr+7i6y8EHgwVNTUoZJMQ=
Message-ID: <490B1AC6.1030705@gmail.com>
Date: Fri, 31 Oct 2008 14:48:38 +0000
From: Iain <selsinork@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Carsten Niehaus <cniehaus@gmx.de>
CC: Rafael Cunha de Almeida <almeidaraf@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Weird behaviour on iwl3945 module
References: <200810311201.03588.cniehaus@gmx.de>
In-Reply-To: <200810311201.03588.cniehaus@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Niehaus wrote:
> Moin
> 
> Is that the same issue as the one I reported agains 2.6.27 on Ubuntu 8.10?
> 
>   https://bugs.launchpad.net/ubuntu/+source/wireless-tools/+bug/290820
> 
> Carsten
> 

The rfkill messages in dmesg are probably meaningless. I see them too and they don't stop the card from working.

What do you get if you type 'ip link' in a shell ?
I think you'll see something like:
wlan0: <NO-CARRIER,BROADCAST,MULTICAST>

You want
wlan0: <NO-CARRIER,BROADCAST,MULTICAST,UP>

to have any hope of getting any further.

On my HP laptop, it's impossible to bring the card up with 'ip link set up dev wlan0' when the hardware button is set to disable the 
wireless interfaces during boot, on at least 2.6.[25,26,27]. However once you press the button and enable the interface you can then 
bring the card up and it'll stay up when you press the button again.

The real problem for me with this is that normally the button is turned off during boot, so the startup scripts can't bring the card 
up and everything else falls apart from there.

Previously I've just been doing 'ip link set up dev wlan0' in an xterm after enabling via the button first time I need to use it, 
having done that, everything works fine.

With 2.6.27 the hp-wmi driver means that I get rfkill uevents over netlink and can use those to bring the card up automatically when 
the button is pressed. Perhaps there's a similar option on your laptops.

FWIW, I'm not using Debian/Ubuntu, or hal/dbus/NetworkManager,  but it was fairly trivial to find lots of discussion of this 
elsewhere, seemingly mostly related to Debian/Ubuntu:
<https://bugs.launchpad.net/ubuntu/intrepid/+source/linux/+bug/193970>
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/267875>
<https://wiki.ubuntu.com/IntrepidReleaseNotes#Cannot%20reactivate%20Intel%203945/4965%20wireless%20if%20booting%20with%20killswitch%20enabled>

Iain
