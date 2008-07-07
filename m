Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYGGIeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYGGIeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 04:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYGGIeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 04:34:05 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:59931 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYGGIeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 04:34:04 -0400
X-Greylist: delayed 1577 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 04:34:04 EDT
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Eric Sesterhenn <snakebyte@gmx.de>
In-Reply-To: <20080706172147.GA19559@alice>
Subject: Re: [Linux-NTFS-Dev] Oops with corrupted NTFS image
References: <20080706172147.GA19559@alice>
Message-Id: <F2EEF4B5-3E11-480A-93E7-9078BDC578EA@cam.ac.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Date: Mon, 7 Jul 2008 09:07:40 +0100
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the report.  Would you be able to try the below change to  
your kernel and repeat?

On 6 Jul 2008, at 18:21, Eric Sesterhenn wrote:
> 0xc030ad5c is in ntfs_read_locked_inode (fs/ntfs/time.h:95).
> 90		u64 t = (u64)(sle64_to_cpu(time) - NTFS_TIME_OFFSET);
> 91		/*
> 92		 * Convert the time to 1-second intervals and the remainder to
> 93		 * 1-nano-second intervals.
> 94		 */
> 95		ts.tv_nsec = do_div(t, 10000000) * 100;
> 96		ts.tv_sec = t;
> 97		return ts;
> 98	}

Please replace the ts.tv_nsec=... and ts.tv_sec=... with:

		if (t) {
			ts.tv_nsec = do_div(t, 10000000) * 100;
			ts.tv_sec = t;
		} else {
			ts.tv_nsec = 0;
			ts.tv_sec = 0;
		}

Thanks a lot in advance!

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

