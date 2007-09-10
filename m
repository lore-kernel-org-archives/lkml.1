Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbXIJN0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbXIJN0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbXIJN0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:26:30 -0400
Received: from trinity.phys.uwm.edu ([129.89.57.159]:58597 "EHLO
	trinity.phys.uwm.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXIJN03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:26:29 -0400
X-Greylist: delayed 4002 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Sep 2007 09:26:29 EDT
Date: Mon, 10 Sep 2007 07:19:35 -0500 (CDT)
From: Bruce Allen <ballen@gravity.phys.uwm.edu>
X-X-Sender: ballen@trinity.phys.uwm.edu
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: ECC and DMA to/from disk controllers
Message-ID: <Pine.LNX.4.63.0709100707210.28162@trinity.phys.uwm.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear LKML,

Apologies in advance for potential mis-use of LKML, but I don't know where 
else to ask.

An ongoing study on datasets of several Petabytes have shown that there 
can be 'silent data corruption' at rates much larger than one might 
naively expect from the expected error rates in RAID arrays and the 
expected probability of single bit uncorrected errors in hard disks.

The origin of this data corruption is still unknown.  See for example 
http://cern.ch/Peter.Kelemen/talk/2007/kelemen-2007-C5-Silent_Corruptions.pdf

In thinking about this, I began to wonder about the following.  Suppose 
that a (possibly RAID) disk controller correctly reads data from disk and 
has correct data in the controller memory and buffers.  However when that 
data is DMA'd into system memory some errors occur (cosmic rays, 
electrical noise, etc).  Am I correct that these errors would NOT be 
detected, even on a 'reliable' server with ECC memory?  In other words the 
ECC bits would be calculated in server memory based on incorrect data from 
the disk.

The alternative is that disk controllers (or at least ones that are meant 
to be reliable) DMA both the data AND the ECC byte into system memory. 
So that if an error occurs in this transfer, then it would most likely be 
picked up and corrected by the ECC mechanism.  But I don't think that 
'this is how it works'.  Could someone knowledgable please confirm or 
contradict?

Cheers,
 	Bruce
