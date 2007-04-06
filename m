Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbXDFTqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbXDFTqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbXDFTqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:46:08 -0400
Received: from mail.tmr.com ([64.65.253.246]:59208 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbXDFTqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:46:06 -0400
Message-ID: <4616A3E0.4070206@tmr.com>
Date: Fri, 06 Apr 2007 15:47:44 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: scdbackup@gmx.net
CC: cdwrite@other.debian.org,
       Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: was once: Samsung DVD writer.
References: <46165A5E.1060709@tmr.com> <20070406155003.1F4372E4C7@murphy.debian.org>
In-Reply-To: <20070406155003.1F4372E4C7@murphy.debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

scdbackup@gmx.net wrote:
> Hi,
>
> BTW: What happened to "FreeBSD User Giacomo" and his Samsung DVD writer ?
>
> Any news to report ? A happy ending perchance ?
>
>
> Bill Davidsen: [about filtering dangerous SCSI commands]
>   
>> My suggestion would be to add an ioctl, like SET_SCSI_UNFILTERED, which
>> can only be used as root, and which would allow SCSI commands sent a
>> device to be persistently set unfiltered.
>>     
>
> I understand that would be for programs like firmware
> updaters, but not for the vanilla purpose of bringing
> data onto an optical disc ?
>
> Because ... if this is intended for daily usage:
>
> I do not think that burning a disc on a desktop should
> necessarily require root privileges. Let's leave it to
> the sysadmin (or distro) to decide who may burn resp.
> may endanger the device by malicious use of normally
> harmless SCSI commands. (Like overworking the drive tray
> motor ?)
>
>   
I don't see a problem here requiring root. Once the filter is turned off 
for the device, say in rc.local, and the ownership and permissions are 
set, there's no issue. It can be owned by root, group cdwriters, have 
permissions 0660, and cdrecord or other trusted programs can be setgid 
once the kernel stop blocking such access.
> After all, what is gained if one performs daily tasks
> as a privileged user ? That only pierces the protection
> against absent-minded mistakes and involuntary backdoors.
>
>   
No need to do any daily tasks in a dangerous mode, access would be 
limited to users and programs regarded as trusted.
> Actually i try to stay away from any kernel peculiarities
> so i do not get addicted to something that might change.
> A pointer to a list of forbidden commands would be welcome
> thus.
>
>   
If this could be added it would presumably not change.
> Maybe cdrskin was up to now only tested on totally insecure
> systems.  After all i never got reports of the ominous
> command filtering interfering with burning. If it prevents
> any of libburn's SCSI commands from being executed then it
> does this silently and does not prevent burning success.
>   

No, as I noted, programs other than cdrecord are clever enough to avoid 
requiring disallowed commands.
> I would like to know, which commands and cease sending them. :))
>
>
> libburn SCSI command list (commands in brackets are defined
> but not in normal use):
> spc.c: 00h, 03h, 12h, 1Eh, 55h, 5Ah,
> sbc.c: 1Bh,
> mmc.c: 04h, 23h, 2Ah, 35h, 43h, 46h, 4Ah, 
>        51h, 52h, 53h, 54h, 5Bh, 5Ch, 5Dh,
>        A1h,(AAh),ACh, B6h, BBh,(BEh), 
>
>
> Have a nice day :)
>   
I put lkml back on the recipients, I'm suggesting a new ioctl as a way 
around the decision to no longer have setuid/setgid actually fully 
functional.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

