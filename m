Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbXI2CPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbXI2CPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 22:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbXI2CPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 22:15:01 -0400
Received: from hogwarts.egr.duke.edu ([152.3.195.84]:44079 "EHLO
	hogwarts.egr.duke.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbXI2CPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 22:15:00 -0400
X-Greylist: delayed 1493 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 22:15:00 EDT
Date: Fri, 28 Sep 2007 21:49:55 -0400 (EDT)
From: Joshua Baker-LePain <jlb17@duke.edu>
X-X-Sender: jlb@hogwarts.egr.duke.edu
To: Benjamin Carr <bcarr@whoi.edu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Sandeen <sandeen@sandeen.net>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: Truncated Filesystem
In-Reply-To: <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
Message-ID: <alpine.LRH.0.9999.0709282145490.22882@hogwarts.egr.duke.edu>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org> <Pine.LNX.4.64.0709281821390.12203@p34.internal.lan> <46FD9006.6050807@sandeen.net> <46FD959E.5030009@zytor.com> <Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 at 8:49pm, Benjamin Carr wrote

>> What kind of partition table is it?  MS-DOS partition tables have a 2 TB
>> limit.
>
> Hadn't thought of that, doesn't look good.
> -Ben
>
> sudo fdisk -l /dev/sdc1
> benc's password:

Issue number one -- don't use fdisk, as it doesn't support devices that 
big.  Use parted instead:

parted /dev/sdc
mklabel gpt
mkpart primary ext2 0 11TB
quit

where you may have to sub some other value for the "11TB" in the mkpart 
line -- I forget the exact syntax.

-- 
Joshua Baker-LePain
QB3 Shared Cluster Sysadmin
UCSF
