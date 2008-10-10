Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbYJJTNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbYJJTNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 15:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761723AbYJJTN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 15:13:29 -0400
Received: from lucidpixels.com ([75.144.35.66]:34980 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759625AbYJJTN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 15:13:28 -0400
Date: Fri, 10 Oct 2008 15:13:26 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Tejun Heo <tj@kernel.org>
cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Tom Mortensen <tmmlkml@gmail.com>, Bill Davidsen <davidsen@tmr.com>,
       Gwendal Grignou <gwendal@google.com>,
       Brian Rademacher <rad@radfiles.net>, linux-ide@vger.kernel.org,
       linux-raid maillist <linux-raid@vger.kernel.org>,
       Linux Kernel Maillist <linux-kernel@vger.kernel.org>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       smartmontools-support@lists.sourceforge.net, xfs@oss.sgi.com
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
In-Reply-To: <alpine.DEB.1.10.0810040410170.14969@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0810101505420.12937@p34.internal.lan>
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>  <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>  <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>  <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>  <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>
  <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>  <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan>  <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>  <48DBAB81.8050900@tmr.com> <48E08E2D.6050905@kernel.org>
 <a52a95e30809301347s70b57ebfh280a6871329afd72@mail.gmail.com> <alpine.DEB.1.10.0809301715280.14600@p34.internal.lan> <alpine.LNX.2.00.0809301946020.16014@filesrv1.baby-dragons.com> <alpine.DEB.1.10.0810010403500.16900@p34.internal.lan>
 <alpine.DEB.1.10.0810010710520.22435@p34.internal.lan> <48E6D481.7050407@kernel.org> <alpine.DEB.1.10.0810040410170.14969@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Oct 2008, Justin Piszcz wrote:

>
>
> On Sat, 4 Oct 2008, Tejun Heo wrote:
>
>> Justin Piszcz wrote:
>>

What do these signifiers mean (they are always the same, no matter the
controller used OR the disk in question (happens across 12 disks and 3 
different controllers)):

[420781.333179] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[420781.333189] ata6.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
                              ^^ ^^(b0/d8)^^ ^^(4f:c2)
[420781.333190]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4
(timeout)                    ^^ 40:00:ff
[420781.333194] ata6.00: status: { DRDY }
[420781.333200] ata6: hard resetting link
[420781.638589] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[420781.662166] ata6.00: configured for UDMA/133
[420781.662166] ata6: EH complete

(at the time there was little to no I/O occuring on this block device, but 
disks on the raid5 volume were being accessed at the time, so there was 
system activity, mainly disk reads 300-500KiB/s over ethernet)

  Nick's(?) problem:

> Nick
> 
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
                ^^ ^^ (ea/00) vs. (b0/d8) - mind are always the same (FYI)
>         res 40/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
               ^^ ^^ (40:00: but no ff)

           The rest of the messages are the same.  Is there any correlation
           that can be made here?  When this happens to others, is it
           always the same codes as shown above or do they change?  If they
           do not change, how come they vary between users who have this
           problem?

> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: configured for UDMA/133
> ata1: EH complete
> sd 1:0:0:0: [sda] 2930277168 512-byte hardware sectors (1500302 MB)
> sd 1:0:0:0: [sda] Write Protect is off
> sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA

Can anything be said about these errors, can we classify them into groups?
Or are they just random? It does not appear to happen more or less with 
one filesystem or another either, one guy is using ext3, I am using XFS-- 
certainly something much deeper..

Justin.
