Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbYHNWLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbYHNWLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYHNWLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:11:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54124 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYHNWLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:11:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48A4AD7A.1070903@s5r6.in-berlin.de>
Date: Fri, 15 Aug 2008 00:11:06 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Alan Stern <stern@rowland.harvard.edu>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       James.Bottomley@HansenPartnership.com, teheo@novell.com,
       oneukum@suse.de
Subject: Re: Power management for SCSI
References: <20080813095055.GA475@elf.ucw.cz> <Pine.LNX.4.44L0.0808131026320.2455-100000@iolanthe.rowland.org> <20080814130812.GC2262@elf.ucw.cz>
In-Reply-To: <20080814130812.GC2262@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> https://lists.linux-foundation.org/pipermail/linux-pm/2008-March/016849.html
...
> First the general comments/questions:
> 
> #
> #1. It's done at the wrong level: suspend "device" is actually a target
> #function.  There's no way on a multi-lun device we want to keep the
> #flags and last_busy anywhere but in the target
> 
> So... if there's one device with Lun0==cdrom1 and Lun1==cdrom2, it is a
> single target, and we want to keep flags/last busy common to all that?

Actually a command set driver like sd surely wants last_busy (time of 
last use) separate for each LU for auto-spindown, doesn't it?

I'm not sure about the rest, i.e. delay, counter, flags.

> What is good data structure to add? I see scsi_tgt*.h, but it is very
> short, and there does not seem to be good structure to hook into.

include/scsi/scsi_tgt*.h are for local target implementations.  The 
representation of "remote" targets, as seen by local initiators, is 
include/scsi/scsi_device.h's struct scsi_target.
-- 
Stefan Richter
-=====-==--- =--- -===-
http://arcgraph.de/sr/
