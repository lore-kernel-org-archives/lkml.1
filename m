Return-Path: <linux-kernel-owner+w=401wt.eu-S1030814AbXDVNDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030814AbXDVNDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 09:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030837AbXDVNDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 09:03:39 -0400
Received: from rtr.ca ([64.26.128.89]:4625 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030814AbXDVNDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 09:03:38 -0400
Message-ID: <462B5D28.2000901@rtr.ca>
Date: Sun, 22 Apr 2007 09:03:36 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Sunil Naidu <akula2.shark@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: Linux 2.6.20.7 - Hard Disk rumbling?
References: <8355959a0704210658j3b54a8cfl8a8a73661cd50c9d@mail.gmail.com>
In-Reply-To: <8355959a0704210658j3b54a8cfl8a8a73661cd50c9d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sunil Naidu wrote:
> Hello,
> 
> I am facing a strange problems with an old 1.2 GHz P-III machine with
> a 10 GB disk (used as a dedicated web server, later retired out of
> service!).
> 
> Out of interest to implement some wireless solution (experiment), I
> did compile 2.6.20.7 for my requirement. Strangely, I did observe:-
> 
> hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
> hda: drive_cmd: error=0x04 { DriveStatusError }
> ide: failed opcode was: 0xb0
> 
> What might be the problem?
> 
> ~Akula2

Opcode 0xb0 is "WIN_SMART".
Error 0x04 is "command aborted/rejected/unsupported".

Something on your system is issuing S.M.A.R.T. commands from userspace
to the drive, and the drive either (1) doesn't support S.M.A.R.T.,
or (2) currently does not have S.M.A.R.T. enabled (smartctl -s on /dev/hda).

The "smartmontools" package is what normally issues these commands.
