Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXHRN2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXHRN2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 09:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXHRN2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 09:28:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57896 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbXHRN2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 09:28:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46C6F3C7.3070002@s5r6.in-berlin.de>
Date: Sat, 18 Aug 2007 15:27:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "Martin K. Petersen" <mkp@mkp.net>
CC: Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: Corrupted filesystem with new Firewire stack
References: <9d2cd630708151447u7e415712u17e974859fbd5481@mail.gmail.com>	<46C3EE1F.40309@s5r6.in-berlin.de> <yq1ps1m5odq.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1ps1m5odq.fsf@sermon.lab.mkp.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
> 
> Stefan> There were some similar reports involving that "status write
> Stefan> for unknown orb".  I haven't found a way to reproduce it; I
> Stefan> noticed it only once in the logs here so far.
> 
> I get those all the time.  Just do heavy ext3 I/O to the drive.
> 
> Happens here on both a G4 and an intel Mini.  Both running FC7.
> 
> Aug 17 08:24:08 mini kernel: firewire_sbp2: status write for unknown orb
> Aug 17 08:25:08 mini kernel: firewire_sbp2: sbp2_scsi_abort
> Aug 17 08:26:36 mini kernel: firewire_sbp2: status write for unknown orb
> Aug 17 08:27:36 mini kernel: firewire_sbp2: sbp2_scsi_abort
> Aug 17 08:33:51 mini kernel: firewire_sbp2: status write for unknown orb
> Aug 17 08:34:51 mini kernel: firewire_sbp2: sbp2_scsi_abort
> 
> Lacie drive in both cases.

I replaced a HDD in my OFXW911 enclosure and am starting tests now.

While backing ~80 GB from its current reiserfs partition up in order to
reformat to ext3, using find | cpio, I got that error 4 times:

Aug 18 13:24:58 stein ReiserFS: sdd1: Using r5 hash to sort names
Aug 18 13:47:41 stein firewire_sbp2: status write for unknown orb
Aug 18 13:48:11 stein firewire_sbp2: sbp2_scsi_abort
Aug 18 14:18:30 stein firewire_sbp2: status write for unknown orb
Aug 18 14:19:00 stein firewire_sbp2: sbp2_scsi_abort
Aug 18 14:50:08 stein firewire_sbp2: status write for unknown orb
Aug 18 14:50:39 stein firewire_sbp2: sbp2_scsi_abort
Aug 18 14:57:24 stein firewire_sbp2: status write for unknown orb
Aug 18 14:57:54 stein firewire_sbp2: sbp2_scsi_abort

cpio finished with exit code 0, and I compared one of the directories
within which a command was aborted after remounting the disk.  Seems
that error was properly recovered from.

I will test if more of these errors occur in write access or with ext3,
but at least I have a way now to get one error per ~20 minutes
continuous IO, on average.  Then I will proceed to examine the new
stack's sources for potential related bugs.  Will take a while though
because I have other projects going on at the moment.
-- 
Stefan Richter
-=====-=-=== =--- =--=-
http://arcgraph.de/sr/
