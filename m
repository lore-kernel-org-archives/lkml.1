Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335Ab0ANBJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0ANBJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 20:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698Ab0ANBJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 20:09:53 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:24918 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0ANBJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 20:09:53 -0500
Date: Wed, 13 Jan 2010 20:08:29 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Adrian von Bidder <avbidder@fortytwo.ch>
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: task imap:2958 blocked for more than 120 seconds
Message-ID: <20100114010829.GE3428@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Adrian von Bidder <avbidder@fortytwo.ch>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
 <201001110834.36865@fortytwo.ch>
 <201001110945.32352@fortytwo.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001110945.32352@fortytwo.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B4E6ED6.0193:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 09:45:31AM +0100, Adrian von Bidder wrote:
> On Monday 11 January 2010 08.34:36 Adrian von Bidder wrote:
> > "btrfs-vol -b" on an 2T btrfs fs (raid 1 mode over 4 disks) on an arm
> >  CPU  has triggered it several times, so it seems a reliable way to
> >  reproduce this.
> > 
> 
> Found it (Debian kernel 2.6.32 on ARM):
> 
> [78260.386272] INFO: task btrfs-vol:10979 blocked for more than 120 seconds.
> [78260.386306] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [78260.386331] btrfs-vol     D c02b080c     0 10979      1 0x00000001
> [78260.386373] [<c02b080c>] (schedule+0x424/0x488) from [<c02b0c9c>] (schedule_timeout+0x1c/0x244)
> [78260.386408] [<c02b0c9c>] (schedule_timeout+0x1c/0x244) from [<c02b0b10>] (wait_for_common+0xdc/0x178)
> [78260.386611] [<c02b0b10>] (wait_for_common+0xdc/0x178) from [<bf29b880>] (merge_reloc_roots+0x15c/0x1a4 [btrfs])
> [78260.386940] [<bf29b880>] (merge_reloc_roots+0x15c/0x1a4 [btrfs]) from [<bf2a3fd8>] (relocate_block_group+0x548/0x5c8 [btrfs])

Blocking here isn't a huge surprise, relocation can involve some long
held locks.  Does this recover?

-chris
