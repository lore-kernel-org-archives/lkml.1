Return-Path: <linux-kernel-owner+w=401wt.eu-S1765197AbXG2PeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765197AbXG2PeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761358AbXG2Pdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:33:53 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:8490 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761333AbXG2Pdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:33:53 -0400
Date: Sun, 29 Jul 2007 09:33:43 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Reading a bad sector does not report failure as 'read error' but
 hangs PC with 'Machine Check Exception'
In-reply-to: <fa.0jeOedb9xyA9k8S1VmCEkqHxsyw@ifi.uio.no>
To: "Hendrik ." <chasake@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46ACB357.4030006@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.0jeOedb9xyA9k8S1VmCEkqHxsyw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hendrik . wrote:
> Last night I discovered a problem in my RAID5 array
> and finally after a lot of tests I narrowed it down to
> a bad sector on one of the hard disks and some goofy
> kernels.
> 
> I just yesterday build a new PC using an existing
> array of 5 disks in RAID 5. I did build the array with
> only 4 out of 5 disks in the system but the rebuild
> processes stopped over and over again apparently at
> the same position. At last I found out that the
> harddisk at the first SATA port had developed some bad
> sectors which made the kernel stop completely when it
> tried to read that sector with the following error on
> the screen:
> 
> HARDWARE ERROR
> CPU 0: Machine Check Exception: 4  Bank 4:
> b200000000070f0f
> TSC b7d4a144d0
> This is not a software problem!
> Run through mcelog --ascii to decode and contact your
> hardware vendor
> Kernel panic - not syncing: Machine check

You should run this through mcelog as it suggests and see what it shows. 
  The kernel should be handling this properly, unless the drive problem 
is causing the controller to do something bad. Note that kernels 2.6.20 
and later use ADMA mode on the nForce4 SATA controller whereas previous 
versions used it essentially like a PATA controller, so it is not 
surprising that the behavior is different.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

