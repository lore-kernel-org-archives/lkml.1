Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbZGXKzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbZGXKzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZGXKzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:55:46 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:19184 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZGXKzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:55:45 -0400
Message-ID: <4A69932E.90906@turknet.net.tr>
Date: Fri, 24 Jul 2009 13:55:42 +0300
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.2pre) Gecko/20090723 Shredder/3.0b4pre
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
CC: Matthew Wilcox <matthew@wil.cx>
Subject: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB
 Disks
References: <4A4472DF.1050900@turknet.net.tr>	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr> <yq1fxdji03l.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1fxdji03l.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 10:55:43.0215 (UTC) FILETIME=[4A4E6FF0:01CA0C4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 05:30 PM, Martin K. Petersen wrote:
> Tarkan>  version=0x00 [no conformance claimed]
>
> Wow, that's super lame.  And somewhat odd because WDC are usually pretty
> good at USB-SATA bridge protocol compliance.  But in any case this is
> unrelated to your problems.
>
> My concern was that our recent changes to the capacity detection in SCSI
> failed for your device.  However, given your attached log it looks like
> it's a USB issue.  And rereading your original log it also looks like
> you had a USB timeout which coincided with READ CAPACITY failing.
>
> So I'm deferring to the USB folks.
>
> Tarkan>  [160848.805027] usb 5-8: reset high speed USB device using
> Tarkan>  ehci_hcd and address 7
>
>    

Martin,

Today, I had time to bisect and you were right: The below commit related 
to capacity detection changes in SCSI subsystem,as you mentioned, seems 
the cause of the problem.

3821d768912a47ddbd6cab52943a8284df88003c is first bad commit
commit 3821d768912a47ddbd6cab52943a8284df88003c
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Sat May 23 11:43:38 2009 -0400

     sd: Detect non-rotational devices

     Detect non-rotational devices and set the queue flag accordingly.

     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:040000 040000 f744f08d73f56e6d8461267c8c5bc4c710d4c9dd 
89eb1f56a7066a22a9ae6b7b916453a78a9dd082 M      drivers





