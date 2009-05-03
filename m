Return-Path: <linux-kernel-owner+w=401wt.eu-S1756586AbZECUjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbZECUjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZECUji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:39:38 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:11765 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbZECUjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=D6CeSRjIjPQ0ISVis2yIsGKN4pc6KOorPXLMw8eR8zSGBzcOBoyvkMY0obdowQoAsg
         3wqGNerarnsU8sbWjnvMey6sY0prfy5tuOFKfPuwQEa7vIvvyMxeCWeCSN/PCyGkatMl
         I2VUDkmH9xY5htHyxggyY5/IsABobb1xjXmPU=
Message-ID: <49FE0105.6010107@gmail.com>
Date: Sun, 03 May 2009 14:39:33 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Panagiotis Papadakos <papadako@csd.uoc.gr>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: 2.6.30-rc4 Weird messages with ext4
References: <200905031508.06053.papadako@csd.uoc.gr>
In-Reply-To: <200905031508.06053.papadako@csd.uoc.gr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panagiotis Papadakos wrote:
> Hi.
> 
> When I connect my ext4 formatted Seagate 1.5 TB USB box,
> I get the messages of the style:
> 
> [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE           
> [sdb] Sense Key : Illegal Request [current]                     
> [sdb] Add. Sense: Logical block address out of range 
> 
> By the way I am not getting such messages with 2.6.29.
> 
> Anyone knows what might be wrong?

Sounds like something's messing up with the disk size detection, as it 
gets detected as a 2TB drive. CCing linux-usb and linux-scsi.

Apr 27 20:42:15 cray-7 kernel: [    7.600940] scsi 2:0:0:0: 
Direct-Access     ST315003 41AS                  PQ: 0 ANSI: 2
Apr 27 20:42:15 cray-7 kernel: [    7.601701] sd 2:0:0:0: Attached scsi 
generic sg2 type 0
Apr 27 20:42:15 cray-7 kernel: [    7.623420] sd 2:0:0:0: [sdb] Very big 
device. Trying to use READ CAPACITY(16).
Apr 27 20:42:15 cray-7 kernel: [    7.624694] sd 2:0:0:0: [sdb] Using 
0xffffffff as device size
Apr 27 20:42:15 cray-7 kernel: [    7.624703] sd 2:0:0:0: [sdb] 
4294967296 512-byte hardware sectors: (2.19 TB/2.00 TiB)
Apr 27 20:42:15 cray-7 kernel: [    7.627074] sd 2:0:0:0: [sdb] Write 
Protect is off
Apr 27 20:42:15 cray-7 kernel: [    7.649077] sd 2:0:0:0: [sdb] Very big 
device. Trying to use READ CAPACITY(16).
Apr 27 20:42:15 cray-7 kernel: [    7.650288] sd 2:0:0:0: [sdb] Using 
0xffffffff as device size
Apr 27 20:42:15 cray-7 kernel: [    7.652566]  sdb: unknown partition table
Apr 27 20:42:15 cray-7 kernel: [    7.674807] sd 2:0:0:0: [sdb] Attached 
SCSI disk
Apr 27 20:42:15 cray-7 kernel: [    7.683409] sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Apr 27 20:42:15 cray-7 kernel: [    7.683418] sd 2:0:0:0: [sdb] Sense 
Key : Illegal Request [current]
Apr 27 20:42:15 cray-7 kernel: [    7.683425] sd 2:0:0:0: [sdb] Add. 
Sense: Logical block address out of range
