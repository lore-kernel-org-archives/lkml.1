Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbXBNQ7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbXBNQ7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXBNQ7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:59:04 -0500
Received: from mta15.adelphia.net ([68.168.78.77]:52944 "EHLO
	mta15.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbXBNQ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:59:03 -0500
Message-ID: <45D33FD4.8040606@adelphia.net>
Date: Wed, 14 Feb 2007 11:59:00 -0500
From: David G Hamblen <dhamblen@adelphia.net>
Reply-To: dhamblen@adelphia.net
User-Agent: Thunderbird 1.5.0.7 (X11/20060927)
MIME-Version: 1.0
To: Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Problem with 2.6.20 and hostap_cs (Netgear MA401)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've got the ieee80211 and hostap code compiled as modules for my MA401 
card,  and the system locks up when I insert the card.  No keyboard, no 
sysrq, no logs after reboot, no nothing. The same configuration works 
fine under 2.6.19.

If I first insert my old 3com 3c589 card, then eject it and rmmod the 
3c589_cs module, the insertion of the MA401 works completely. Preloading 
the modules with insmod or modprobe doesn't help.

Was there a change in the pcmcia or networking initialization code 
between 2.6.19 and 2.6.20?

Here are the relevant modules.

#/sbin/lsmod
Module                  Size  Used by
ieee80211_crypt_wep     5248  0
hostap_cs              59220  3
hostap                110852  1 hostap_cs
ieee80211_crypt         5632  2 ieee80211_crypt_wep,hostap
...
pcmcia                 29280  1 hostap_cs
firmware_class          9664  1 pcmcia
yenta_socket           26892  4
...
rsrc_nonstatic         13248  1 yenta_socket
pcmcia_core            39056  4 \ 
hostap_cs,pcmcia,yenta_socket,rsrc_nonstatic

