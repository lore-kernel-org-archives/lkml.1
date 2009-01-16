Return-Path: <linux-kernel-owner+w=401wt.eu-S1764827AbZAPXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764827AbZAPXOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZAPXN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:13:59 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:42572 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbZAPXN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:13:58 -0500
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [regression] hp-wmi: hangs system on boot
Date: Sat, 17 Jan 2009 00:13:54 +0100
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901170013.55786.elendil@planet.nl>
X-OriginalArrivalTime: 16 Jan 2009 23:13:56.0355 (UTC) FILETIME=[1B007D30:01C97830]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I first booted .29-rc2 my HP 2510p notebook hung while loading
hp-wmi, which I have listed in /etc/modules. Hard poweroff was needed.

The last line on the console was:
input: HP WMI hotkeys as /class/input/input11

After commenting out hp-wmi in /etc/modules the system booted correctly.

After the successful boot I tried loading the module manually using
modprobe, which resulted in:
input: HP WMI hotkeys as /class/input/input11
iwlagn: Radio Frequency Kill Switch is On:
Kill switch must be turned off for wireless networking to work.
wlan0: No ProbeResp from current AP 00:14:c1:38:e5:15 - assume out of range
iwlagn: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5
mac80211-phy0: failed to remove key (0, 00:14:c1:38:e5:15) from hardware (-5)
iwlagn: Error sending REPLY_ADD_STA: enqueue_hcmd failed: -5
mac80211-phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardware (-5)

I also noticed that /sys/bus/platform/devices/hp-wmi/dock is missing.
And I lost my wireless connection.

Difference between loading hp-wmi from /etc/modules and manually could be
that normally wlan is started _after_ /etc/modules is processed. So with
the hang wlan was not yet active, while for the manual modprobe wlan was
active.

With 2.6.28 hp-wmi works perfectly.

System is running x84_64, Debian Lenny.

Cheers,
FJP
