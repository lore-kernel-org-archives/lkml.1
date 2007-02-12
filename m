Return-Path: <linux-kernel-owner+w=401wt.eu-S1030490AbXBLXcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbXBLXcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030492AbXBLXcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:32:12 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:49527 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030490AbXBLXcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:32:11 -0500
Message-ID: <45D0F8EE.7020604@citd.de>
Date: Tue, 13 Feb 2007 00:31:58 +0100
From: Matthias Schniedermeyer <ms@citd.de>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
References: <200702121502.17130.fink@mpe.mpg.de> <200702121727.17108.fink@mpe.mpg.de> <p731wkvi5go.fsf@bingen.suse.de> <200702121856.29729.fink@mpe.mpg.de>
In-Reply-To: <200702121856.29729.fink@mpe.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin A. Fink wrote:
> I have to store big amounts of data coming from 2 digital cameras to disk. 
> Thus I have to write blocks of around 1 MB at 30 to 50 frames per second for 
> a long period of time. So it is important for me that the harddisk drive is 
> reliable in the sense of "if it is capable of 50 MB/s then it should operate 
> at this speed. Constantly."

The good old handful of suggestions:

- Use a dedicated disc for the task.
- Use an empty disc so there is no fragmentation.
- Buy a bigger disk, they have high bandwidths.
- Buy a more "specialized" disc.
  for e.x.: Western Digital Raptor X(*) a 150GB, 10-KRPM S-ATA disc.
- Buy several discs and use RAID 0
  or alternate between discs when writing.
- use XFS. AFAIK XFS has about the best "large file" and "high
bandwidth" characteristics.
- that with XFS you can preallocate the files doesn't seem relevant in
this case. It's more for the case that you write several files
simultaneously over a longer period of time.
- Write to one large file and separate the individual files later.

if you are sure that you don't get a power-failure:
- Disable Write-Barriers, especially on a logging-filesystem.
- Enable write-caching.
(hdparm doesn't appear to be able to do that with a SATA-disc, but
blktool appears to be able to)
The later has a good chance of corrupting your filesystem when you do
get a power-failure!!!



*:
I don't think you want something from the server-line,
SCSI/FibreChannel/...?
IIRC i read a something about the first 100MB/s disc with in the 15-KRPM
league.

Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated,
cryptic, powerful, unforgiving, dangerous.

