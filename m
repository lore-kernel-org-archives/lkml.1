Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbZC3UVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbZC3UVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbZC3UVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:21:14 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:40401 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbZC3UVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:21:13 -0400
Message-ID: <49D129B4.1060503@msgid.tls.msk.ru>
Date: Tue, 31 Mar 2009 00:21:08 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <49D0FD4C.1010007@redhat.com> <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain> <49D11BDD.70702@redhat.com> <49D1206E.7090809@garzik.org>
In-Reply-To: <49D1206E.7090809@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
[]
> IDEALLY, according to the SATA protocol spec, we could issue up to 32 
> NCQ commands to a SATA drive, each marked with the "FUA" bit to force 
> the command to hit permanent media before returning.
> 
> In theory, this NCQ+FUA mode gives the drive maximum ability to optimize 
> parallel in-progress commands, decoupling command completion and command 
> issue -- while also giving the OS complete control of ordering by virtue 
> of emptying the SATA tagged command queue.
> 
> In practice, NCQ+FUA flat out did not work on early drives, and 
> performance was way under what you would expect for parallel write-thru 
> command execution.  I haven't benchmarked NCQ+FUA in a few years; it 
> might be worth revisiting.

But are there drives out there that actually supports FUA?

The only cases I've seen dmesg DIFFERENT from something like

  sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
       doesn't support DPO or FUA
       ^^^^^^^^^^^^^^^^^^^^^^^^^^

is with SOME SCSI drives.  Even most modern SAS drives I've seen
reports lack of support for DPO or FUA.  Or at least kernel
reports that.

In the SATA world, I've seen no single case.  Seagate (7200.9..7200.11,
Barracuda ES and ES2), WD (Caviar CE, Caviar Black, Caviar Green,
RE2 GP), Hitachi DeskStar and UltraStar (old and new), some others --
all the same, no DPO or FUA.

/mjt
