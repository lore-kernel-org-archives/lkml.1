Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbYHDTyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbYHDTyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbYHDTyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:54:36 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:53612 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753273AbYHDTyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:54:35 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=L4ZVBCqTRzGetBOK8xYA:9 a=MvpRr7ROSrCSptGr_RwA:7 a=l69JNAV75PrFQRAxlXP2oPC1QJ0A:4 a=XY8dIlDO8zIA:10 a=R8QeYpb7sUUA:10
Message-ID: <48975E79.8010207@shaw.ca>
Date: Mon, 04 Aug 2008 13:54:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG and unresponsive system using cdparanoia on 2.6.26
References: <fa.oIy/kfKdsiZFNy+hmBNbNiOY6F8@ifi.uio.no>
In-Reply-To: <fa.oIy/kfKdsiZFNy+hmBNbNiOY6F8@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> Hi
> 
> 2 problems:
> * unresponsive system
> * BUG
> 
> I've been ripping some audio CDs recently under 2.6.26 and sometimes, I assume
> when there have been imperfections/retries etc, the system has become
> unresponsive - 10s of seconds for mouse movement, keystrokes to respond.
> 
> This resulted in many
>   kernel: ide: failed opcode was: unknown
>   kernel: hda: drive not ready for command
>   kernel: hda: status timeout: status=0xff { Busy }

Yeah, presumably the drive has gone off into never never land trying to 
read the disc for a long time..

> 
> top reported very high %si (>95%)
> 
> 
> and when I tried (*something*) to recover using:
>   hdparm -w /dev/hda
>   hdparm -w /dev/hdb
> I got a BUG.
> 
> I know it says 'dangerous' - so if the reply is "so don't do that then" I shall
> respect it :)
> OTOH this may be unexpected so I'm reporting it.

Well, it's likely not "expected", but it's not generally a good thing to 
do as it triggers not-well-tested code paths.. The IDE layer is supposed 
to reset the drive itself in this case, and it appears it does.. but 
then the command likely either gets retried or the next command comes in 
and stalls the drive out again.

> 
> All my drives are on sata channels, I just have a Plextor CDRW and a DVDRW on
> the ide channel.
> 
> One additional comment, when the CD drive gets into this state, it persists
> after a hibernate, cold boot and restore. It is fine after a cold reboot.
> This suggests to me that the problem may be in the kernel/driver.
> 
> Let me know what else I can provide to help.
> In the meantime I'll be trying 2.6.27-rc?

Well, my recommendation would be first to try the newer libata driver 
for your PATA controller and not use the old IDE layer (CONFIG_IDE). 
libata drivers should be more robust against this sort of thing..
