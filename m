Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbXGWQ1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbXGWQ1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763300AbXGWQ1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:27:03 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:8746 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762685AbXGWQ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:27:01 -0400
Date: Mon, 23 Jul 2007 10:26:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SCSI vs SATA
In-reply-to: <fa.SvaaC7eLt94EpLFzyKwtVPKbm3s@ifi.uio.no>
To: BuraphaLinux Server <buraphalinuxserver@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46A4D6CA.2050006@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.SvaaC7eLt94EpLFzyKwtVPKbm3s@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BuraphaLinux Server wrote:
> Hello,
> 
>    I have had a hard time determining if /dev/sda is SCSI or SATA
> from my boot scripts.  It matters for smartd which needs an added
> parameter -d sat in the configuration file for SATA drives.  Finally I
> came up with this, but I wonder if there is a better way?  It appears
> that
> vendor is "ATA     " (5 trailing spaces) for SATA.  If the kernel is
> ever fixed to show proper vendor information (Maxtor, Seagate,
> whatever) then how can I know if /dev/sda is SCSI or SATA from a bash
> script?  When flaming me, please also include the proper solution.
> Thanks.
> 
> #!  /bin/bash
> drive="sda"
> vendor=$(</sys/block/${drive}/device/vendor)
> if [[ "${vendor}" = "ATA     " ]]
> then
>  printf "SATA\n"
> else
>  printf "SCSI\n"
> fi
> exit 0

libata follows the SAT standard for ATA device identification as a SCSI 
device, which specifies the vendor is always supposed to be ATA. 
Checking for vendor ATA is likely safe then, though if it's not you 
can't assume it's going to be SCSI as it could also be USB, IEEE1394, etc.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

