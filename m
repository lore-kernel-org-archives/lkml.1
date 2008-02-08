Return-Path: <linux-kernel-owner+w=401wt.eu-S934456AbYBHSy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbYBHSy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760794AbYBHSyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:54:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760790AbYBHSys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:54:48 -0500
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 11/9] firewire: fw-sbp2: enforce a retry of __scsi_add_device if bus generation changed
Date: Fri, 8 Feb 2008 13:54:23 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <47A9FBFD.50100@s5r6.in-berlin.de> <tkrat.b66856ee2df66cd4@s5r6.in-berlin.de>
In-Reply-To: <tkrat.b66856ee2df66cd4@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081354.23299.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2008 04:09:47 pm Stefan Richter wrote:
> fw-sbp2 is unable to reconnect while performing __scsi_add_device
> because there is only a single workqueue thread context available for
> both at the moment.  This should be fixed eventually.
>
> Until then, take care that __scsi_add_device does not return success
> even though the SCSI high-level driver probing failed (sd READ_CAPACITY
> and friends) due to bus reset.  The trick to do so is to use a different
> error indicator in the command completion as long as __scsi_add_device
> did not return.
>
> An actual failure of __scsi_add_device is easy to handle, but an
> incomplete execution of __scsi_add_device with an sdev returned would
> remain undetected and leave the SBP-2 target unusable.
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>
> Jarod, does this work like I assume and fixes your setup of two OXFW911
> based disks?

Well, it results in the dmesg spew saying "sd 6:0:0:0: [sdc] Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK" -- i.e., 
DID_NO_CONNECT instead of DID_BUS_BUSY, but other than that, no change in 
behavior, sdc remains unusable just as before.


-- 
Jarod Wilson
jwilson@redhat.com
