Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbYABVFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbYABVFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 16:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYABVE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 16:04:58 -0500
Received: from proxy1.bredband.net ([195.54.101.71]:46030 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbYABVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 16:04:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlF4AA+Le0dT48OPRmdsb2JhbACBV44wAQEBN4Eili8
Message-ID: <477BFC71.7090002@coderworld.net>
Date: Wed, 02 Jan 2008 22:04:49 +0100
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: forcedeth: MAC-address reversed on resume from suspend
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugreport regarding forcedeth driver.

When returning from suspend-to-RAM the MAC-address byteorder is 
reversed. After another suspend-resume cycle the MAC-address is again 
correct. This brings a great deal of pain since the NIC is assigned a 
random MAC-address when it is detected as invalid.

I cannot say if this issue appeared recently or if it's been in the 
kernel for a while, as I've been using wireless until recently.

I read somewhere on lkml that the mac is read from the device, then 
reversed and finally written back to the device. Can it be that it is 
read again on resume and reversed, and then again written to the device? 
This would explain why it's ok every other resume cycle.

MAC is always correct when cold booting.

Random computer info:
HP dv2140eu, amd64 smp, nvidia mcp51, kernel 2.6.24-rc3, ubuntu feisty

dmesg when fail:
forcedeth 0000:00:14.0: Invalid Mac address detected: e1:97:11:d3:16:00
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 
00:00:6c:1e:34:69

dmesg when good:
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 
00:16:d3:11:97:e1
