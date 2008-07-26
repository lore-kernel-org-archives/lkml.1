Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYGZDoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYGZDoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 23:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYGZDoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 23:44:02 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4968 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751571AbYGZDoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 23:44:01 -0400
Date: Fri, 25 Jul 2008 23:43:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       SCSI Kernel <linux-scsi@vger.kernel.org>
Subject: Re: [SCSI] can't plug Nokia 5300 anymore (bisected)
In-Reply-To: <488A3A8A.7000603@belbone.be>
Message-ID: <Pine.LNX.4.44L0.0807252342570.7216-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008, Cédric Godin wrote:

> resending because wrong address of lkml and cc scsi list
> 
> Hello,
> 
> since 2 or 3 -git kernels (Linus tree)  I have a problem with my laptop 
> and its connection through USB to a nokia 5300 gsm.
> 
> The logs show me a endless loop (until i unplug my USB cable) of 
> following messages :
> 
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
> 
> I bisected the kernel and found the following commit as result :
> 
> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
> commit 427e59f09fdba387547106de7bab980b7fff77be
> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date:   Sat Mar 8 18:24:17 2008 -0600
> 
>    [SCSI] make use of the residue value
> 
>    USB sometimes doesn't return an error but instead returns a residue
>    value indicating part (or all) of the command wasn't completed.  So if
>    the driver _done() error processing indicates the command was fully
>    processed, subtract off the residue so that this USB error gets
>    propagated.
> 
>    Cc: Alan Stern <stern@rowland.harvard.edu>
>    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd 
> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
> 
> 
> When reverting it with 2.6.26-06077-gc010b2f , everything is back to normal.

Can you post the corresponding dmesg log from a system built with 
CONFIG_USB_STORAGE_DEBUG enabled?

Alan Stern

