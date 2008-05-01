Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbYEAPGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbYEAPGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761925AbYEAPF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:05:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48842 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761907AbYEAPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:05:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4819DC1F.1050904@s5r6.in-berlin.de>
Date: Thu, 01 May 2008 17:05:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: dpn@isomerica.net
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, krh@redhat.com,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-git16 -- BUG: unable to handle kernel NULL pointer dereference
 at 00000000 -- IP: [<c02dd5d5>] fw_show_drv_device_ids+0xd9/0xee
References: <a44ae5cd0804301729q77530ecerdbb65b4ed40eeba@mail.gmail.com>	 <tkrat.39b6a8e0dced1929@s5r6.in-berlin.de> <a44ae5cd0805010608n6c441082udd00c315e786de40@mail.gmail.com> <4819C941.6030209@s5r6.in-berlin.de> <4819D5A1.6080204@isomerica.net>
In-Reply-To: <4819D5A1.6080204@isomerica.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Noé wrote:
> I like to be warned about things, even if there isn't anything I can 
> really do about it (fix my IEEE 1394 ROM CRC? :) But there doesn't seem 
> to be any point to repeating the message.
> 
> Do the repeats come because it prints each time the config ROM is accessed?

There are three reasons which cause repetition:

   - While we fetch and parse the config ROM, another bus resets happens.
     We then need to start over reading the config ROM.  This kind of
     repetition cannot easily be prevented, but hopefully happens less
     often.

   - A variation of the theme:  Device plugged out, plugged in again.
     Causes the config ROM to be at least partially fetched and parsed
     again.

   - If the firmware author did the CRC algorithm wrong, he got it wrong
     for the bus information block, the root directory, and each
     subdirectory or leaf (unit directories, instance directories,
     textual descriptor leaves, icon descriptors...).  Giving a log
     notice about each of these CRCs is surely redundant.

When I added the log notice, I didn't try to suppress at least the 
latter kind of repetition because I figured that this kind of mistake is 
rare nowadays.  (If I'm not mistaken, there have for example been 
clarifications in IEEE 1212-2001.)  Of course it isn't rare to those 
people who happen to work with affected devices all the time.  So I will 
try to reduce the log spam.

BTW, "fix my IEEE 1394 ROM CRC" can sometimes be done by firmware update.
-- 
Stefan Richter
-=====-==--- -=-= ----=
http://arcgraph.de/sr/
